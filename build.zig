const std = @import("std");
const Build = std.Build;

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var execOptions = Build.ExecutableOptions{
        .name = "LeagueOfLanguages",
        .root_source_file = Build.LazyPath{
            .cwd_relative = "src/main.zig"
        },
        .target = target,
        .optimize = optimize
    };
    const exe = b.addExecutable(execOptions);
    exe.subsystem = .Console;
    exe.addLibraryPath(Build.LazyPath{
        .cwd_relative = "deps/lib"
    });
    exe.addSystemIncludePath(Build.LazyPath{
        .cwd_relative = "deps/include"
    });
    exe.linkLibC();
    exe.linkLibCpp();
    exe.linkSystemLibrary("SDL2");
    exe.linkSystemLibrary("SDL2_image");
    
    exe.addObjectFile(Build.LazyPath{.cwd_relative = "deps/lib/SDL2.dll"});
    exe.addObjectFile(Build.LazyPath{.cwd_relative = "deps/lib/SDL2_image.dll"});
    
    b.default_step.dependOn(&exe.step);
    b.installBinFile("./deps/lib/SDL2.dll", "SDL2.dll");
    b.installBinFile("./deps/lib/SDL2.dll", "SDL2_image.dll");
    b.installArtifact(exe);

    const run = b.step("run", "Run the game");
    const run_cmd = b.addRunArtifact(exe);
    run.dependOn(&run_cmd.step);
}
