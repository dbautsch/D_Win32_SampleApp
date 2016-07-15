module winmain;

import core.runtime;
import core.sys.windows.windows;
import core.stdc.string;
import std.utf;

const int ID_DEMO_BUTTON = 10;
const int ID_CLOSE_BUTTON = 11;

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

	HWND h;

	try {
		CreateMainWindow(&h);
		CreateControls(h);
		StartApplicationLoop(h);
		FinishApplication(&h);
	}
	catch (Throwable o) {
		throw o;
	}

    return 0;
}

void CreateMainWindow(HWND * h) {
	
	WNDCLASSEX wc;

	*h  = null;

	string className	= "D_Win32Class";
	string appName		= "D_Win32_SampleApp";

	wc.cbSize			= wc.sizeof;
	wc.lpfnWndProc		= &MainWindowProc;
	wc.hIcon			= LoadIcon(NULL, IDI_APPLICATION);
	wc.hIconSm			= LoadIcon(NULL, IDI_APPLICATION);
	wc.hbrBackground	= cast (HBRUSH) COLOR_WINDOW;
	wc.lpszClassName	= toUTF16z(className);

	if (RegisterClassEx(&wc) == false) {
		throw new Exception("Failed to register window class.");
	}

	* h = CreateWindowEx(WS_EX_APPWINDOW,
						 toUTF16z(className),
						 toUTF16z(appName),
						 WS_OVERLAPPEDWINDOW,
						 100,
						 100,
						 640,
						 480,
						 null,
						 null,
						 null,
						 null);

	if (* h == null)
		throw new Exception("Failed to create window.");
}

void CreateControls(HWND h) {

	HWND button = CreateWindow(toUTF16z("BUTTON"),
							   toUTF16z("Click Me!"),
							   WS_VISIBLE | WS_CHILD,
							   10,
							   10,
							   110,
							   24,
							   h,
							   cast(void*)ID_DEMO_BUTTON,
							   null,
							   null);

	HWND close = CreateWindow(toUTF16z("BUTTON"),
							  toUTF16z("Close"),
							  WS_VISIBLE | WS_CHILD,
							  130,
							  10,
							  110,
							  24,
							  h,
							  cast(void*)ID_CLOSE_BUTTON,
							  null,
							  null);

}

void StartApplicationLoop(HWND h) {

	MSG msg;

	ShowWindow(h, SW_SHOW);

	while (GetMessage(&msg, null, 0, 0)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
}

void FinishApplication(HWND * h) {

	if (h && * h) {
		DestroyWindow(*h);
		* h = null;
	}
}

extern (Windows)
LRESULT MainWindowProc(HWND h, UINT msg, WPARAM wParam, LPARAM lParam) nothrow {

	switch (msg) {
		case WM_CLOSE:
		{
			PostQuitMessage(0);
			break;
		}

		case WM_COMMAND:
		{
			switch (LOWORD(wParam)) {
				case ID_DEMO_BUTTON:
				{
					MessageBox(h, "You clicked a button!", "Button", MB_ICONINFORMATION);
					break;
				}

				case ID_CLOSE_BUTTON:
				{
					SendMessage(h, WM_CLOSE, 0, 0);
					break;
				}

				default:
					break;
			}
			break;
		}

		default:
			break;
	}	

	return DefWindowProc(h, msg, wParam, lParam);
}
