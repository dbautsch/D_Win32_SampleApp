module winmain;

import core.runtime;
import core.sys.windows.windows;

extern (Windows)
int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    int result;

    try {
        Runtime.initialize();

        result = customWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);

        Runtime.terminate();
    }
    catch (Throwable o) {
        MessageBoxA(null, cast(char *)o.toString(), "Error", MB_OK | MB_ICONEXCLAMATION);
        result = 0;    
    }

    return result;
}

int customWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {

    return 0;
}
