#include <dinput.h>
#include <iostream>
#include <windows.h>

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

void CaptureInput() {
    if (!g_pJoystick) {
        std::cerr << "Joystick não inicializado." << std::endl;
        return;
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

    if (count == 3) {
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

int main() {
    if (FAILED(DirectInput8Create(GetModuleHandle(nullptr), DIRECTINPUT_VERSION,
                                  IID_IDirectInput8, (VOID**)&g_pDI, nullptr))) {
        std::cerr << "Falha ao inicializar DirectInput." << std::endl;
        return 1;
    }

    if (FAILED(g_pDI->EnumDevices(DI8DEVCLASS_GAMECTRL, EnumJoysticksCallback,
                                  g_pDI, DIEDFL_ATTACHEDONLY))) {
        std::cerr << "Falha ao enumerar dispositivos." << std::endl;
        return 1;
    }

    if (g_pJoystick) {
        g_pJoystick->SetDataFormat(&c_dfDIJoystick2);
        g_pJoystick->SetCooperativeLevel(nullptr, DISCL_BACKGROUND | DISCL_NONEXCLUSIVE);
        g_pJoystick->Acquire();
    } else {
        std::cerr << "Nenhum joystick encontrado." << std::endl;
        return 1;
    }

    while (true) {
        CaptureInput();
        Sleep(100); // tempo pra n explodir o processador
    }

    if (g_pJoystick) g_pJoystick->Unacquire();
    if (g_pJoystick) g_pJoystick->Release();
    if (g_pDI) g_pDI->Release();

    return 0;
}
