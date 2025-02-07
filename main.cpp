#define DIRECTINPUT_VERSION 0x0800

#include <dinput.h>
#include <iostream>
#include <windows.h>
#include <atomic>
#include <thread>

std::atomic<bool> running(true);

int count = 3;

LPDIRECTINPUT8 g_pDI = nullptr;
LPDIRECTINPUTDEVICE8 g_pJoystick = nullptr;

BOOL CALLBACK EnumJoysticksCallback(const DIDEVICEINSTANCE* pdidInstance, VOID* pContext) {
    std::cout << "Dispositivo encontrado: " << pdidInstance->tszProductName << std::endl;
    LPDIRECTINPUT8 pDI = (LPDIRECTINPUT8)pContext;

    if (FAILED(pDI->CreateDevice(pdidInstance->guidInstance, &g_pJoystick, nullptr))) {
        return DIENUM_CONTINUE;
    }

    return DIENUM_STOP;
}

void PressKey(WORD virtualKey) {
    INPUT input;
    input.type = INPUT_KEYBOARD;
    input.ki.wVk = virtualKey;
    input.ki.wScan = 0;
    input.ki.dwFlags = 0;
    input.ki.time = 0;
    input.ki.dwExtraInfo = 0;

    SendInput(1, &input, sizeof(INPUT));

    input.ki.dwFlags = KEYEVENTF_KEYUP;
    SendInput(1, &input, sizeof(INPUT));
}

void CaptureInput(bool success) {
    if (!g_pJoystick && !success) {
        std::cerr << "joystick nao inicializado." << std::endl;
        system("start fpgrars-x86_64-pc-windows-msvc--unb.exe main.asm");

        exit(0);
    }

    HRESULT hr = g_pJoystick->Poll();
    if (FAILED(hr)) {
        g_pJoystick->Acquire();
        return;
    }

    DIJOYSTATE2 js;
    hr = g_pJoystick->GetDeviceState(sizeof(DIJOYSTATE2), &js);
    if (FAILED(hr)) {
        return;
    }

    if (js.lX < 16384 && js.lY < 16384) {
        //std::cout << "Diagonal superior esquerda. Pressionando Q." << std::endl;
        PressKey(0x4A); // J
    } else if (js.lX > 49152 && js.lY < 16384) {
        //std::cout << "Diagonal superior direita. Pressionando E." << std::endl;
        PressKey(0x4B); // K
    } else if (js.lX < 16384 && js.lY > 49152) {
        //std::cout << "Diagonal inferior esquerda. Pressionando Z." << std::endl;
        PressKey(0x4E); // N 
    } else if (js.lX > 49152 && js.lY > 49152) {
        //std::cout << "Diagonal inferior direita. Pressionando C." << std::endl;
        PressKey(0x4D); // M
    } else if (js.lY < 16384) {
        //std::cout << "Para cima. Pressionando W." << std::endl;
        PressKey(0x57); // W
    } else if (js.lY > 49152) {
        //std::cout << "Para baixo. Pressionando S." << std::endl;
        PressKey(0x53); // S
    } else if (js.lX < 16384) {
        //std::cout << "Para esquerda. Pressionando A." << std::endl;
        PressKey(0x41); // A
    } else if (js.lX > 49152) {
        //std::cout << "Para direita. Pressionando D." << std::endl;
        PressKey(0x44); // D
    }

    if (count == 3) { // timer para evitar segurar o E
        for (int i = 0; i < 32; i++) {
            if (js.rgbButtons[i] & 0x80) {
                if (i == 0) {
                    PressKey(0x45); // E
                    //std::cout << "tecla E pressionada\n";
                    count = 0;
                }
            }
        }
    }
    else {
        count++;
    }
}

void MonitorFpgrars(HANDLE hProcess) {
    WaitForSingleObject(hProcess, INFINITE); //aguarda o término do processo `fpgrars`
    std::cout << "fpgrars encerrado\n";
    running = false; // sinaliza para desabilitar o capture input
}

int main() {

    // vai ser ativo quando finalizar o programa C++
    if (!SetConsoleCtrlHandler([](DWORD signal) -> BOOL {
        if (signal == CTRL_C_EVENT) {
            running = false; // desabilita todo o processo de captura de input nos threads
            return TRUE;
        }
        return FALSE;
    }, TRUE)) {
        std::cerr << "erro ao configurar o manipulador de sinais\n";
        return 1;
    }

    if (FAILED(DirectInput8Create(GetModuleHandle(nullptr), DIRECTINPUT_VERSION, IID_IDirectInput8, (VOID**)&g_pDI, nullptr))) {
        std::cerr << "falha ao inicializar DirectInput" << std::endl;
        return 1;
    }

    if (FAILED(g_pDI->EnumDevices(DI8DEVCLASS_GAMECTRL, EnumJoysticksCallback, g_pDI, DIEDFL_ATTACHEDONLY))) {
        std::cerr << "falha ao enumerar dispositivos" << std::endl;
    }

    if (g_pJoystick) {
        g_pJoystick->SetDataFormat(&c_dfDIJoystick2);
        g_pJoystick->SetCooperativeLevel(nullptr, DISCL_BACKGROUND | DISCL_NONEXCLUSIVE);
        g_pJoystick->Acquire();
    } else {
        std::cerr << "nenhum joystick encontrado, encerrando adaptador" << std::endl;
    }

    STARTUPINFO si = {};
    si.cb = sizeof(STARTUPINFO);

    PROCESS_INFORMATION pi;

    const char* arg = "\"fpgrars-x86_64-pc-windows-msvc--unb.exe\" \"main.asm\"";
    bool success = CreateProcess(nullptr, LPSTR(arg), nullptr, nullptr, FALSE, 0, nullptr, nullptr, &si, &pi);

    if (!success) {
        std::cerr << "falha ao iniciar o fpgrars\nCODIGO ERRO: " << GetLastError();
        return 1;
    }

    std::thread monitorThread(MonitorFpgrars, pi.hProcess);

    while (running) {
        CaptureInput(success);
        Sleep(100); // evita sobrecarregar o processador
    }

    TerminateProcess(pi.hProcess, 0); // garante que o fpgrars será encerrado
    monitorThread.join();

    if (g_pJoystick) g_pJoystick->Unacquire();
    if (g_pJoystick) g_pJoystick->Release();
    if (g_pDI) g_pDI->Release();

    std::cout << "programa encerrado\n";
    return 0;
}
