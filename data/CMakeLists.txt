cmake_minimum_required(VERSION 3.10)
project(ProjetoISC)

set(DIRECTX_SDK_INCLUDE_DIR "data\\DirectX\\Include")

include_directories(${DIRECTX_SDK_INCLUDE_DIR})

add_executable(ProjetoISC main.cpp)
target_link_libraries(ProjetoISC dinput8 dxguid)
