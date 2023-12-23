const sdl = @import("deps/SDL.zig");
const sdlImage = @import("deps/SDLImage.zig");
const std = @import("std");
const assert = std.debug.assert;

const screenWidth = 640;
const screenHeight = 480;

pub fn main() !void {
    if (sdl.SDL_Init(sdl.SDL_INIT_VIDEO) != 0) {
        sdl.SDL_Log("Unable to initialize SDL: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer sdl.SDL_Quit();

    std.debug.print("{s}", .{"lol"});
    
    const flagsToLoad = sdlImage.IMG_INIT_PNG;
    if(sdlImage.IMG_Init(flagsToLoad) != flagsToLoad) {
        std.debug.print("{s}", .{"top kek we failed"});
        sdl.SDL_Log("Unable to initialize SDL_image: %s", sdlImage.IMG_GetError());
        return error.SDLInitializationFailed;
    }
    
    const screen = sdl.SDL_CreateWindow(
        "League of Languages",
        sdl.SDL_WINDOWPOS_UNDEFINED,
        sdl.SDL_WINDOWPOS_UNDEFINED,
        screenWidth,
        screenHeight,
        sdl.SDL_WINDOW_OPENGL
    ) orelse
    {
        sdl.SDL_Log("Unable to create window: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer sdl.SDL_DestroyWindow(screen);

    const renderer = sdl.SDL_CreateRenderer(
        screen,
        -1,
        0
    ) orelse {
        sdl.SDL_Log("Unable to create renderer: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer sdl.SDL_DestroyRenderer(renderer);
    
    const zig_bmp = @embedFile("zig.bmp");
    const rw = sdl.SDL_RWFromConstMem(zig_bmp, zig_bmp.len) orelse {
        sdl.SDL_Log("Unable to get RWFromConstMem: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer assert(sdl.SDL_RWclose(rw) == 0);

    const zig_surface = sdl.SDL_LoadBMP_RW(rw, 0) orelse {
        sdl.SDL_Log("Unable to load bmp: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer sdl.SDL_FreeSurface(zig_surface);

    const zig_texture = sdl.SDL_CreateTextureFromSurface(renderer, zig_surface) orelse {
        sdl.SDL_Log("Unable to create texture from surface: %s", sdl.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer sdl.SDL_DestroyTexture(zig_texture);

    var quit = false;
    while (!quit) {
        var event: sdl.SDL_Event = undefined;
        while (sdl.SDL_PollEvent(&event) != 0) {
            switch (event.@"type") {
                sdl.SDL_QUIT => {
                    quit = true;
                },
                sdl.SDL_KEYDOWN => {
                    
                },
                else => {},
            }
        }
        
        _ = sdl.SDL_RenderClear(renderer);
        _ = sdl.SDL_RenderCopy(renderer, zig_texture, null, null);
        sdl.SDL_RenderPresent(renderer);

        sdl.SDL_Delay(17);
    }
}
