const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = std.Build.addStaticLibrary(b, .{
        .name = "wren",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    lib.installHeadersDirectory("src/include", "");

    const sources = [_][]const u8{
        "src/optional/wren_opt_random.c",
        "src/optional/wren_opt_meta.c",
        "src/vm/wren_compiler.c",
        "src/vm/wren_core.c",
        "src/vm/wren_debug.c",
        "src/vm/wren_primitive.c",
        "src/vm/wren_utils.c",
        "src/vm/wren_value.c",
        "src/vm/wren_vm.c",
    };

    lib.addIncludePath(.{ .path = "src/include" });
    lib.addIncludePath(.{ .path = "src/vm" });
    lib.addIncludePath(.{ .path = "src/optional" });

    // lib.addCSourceFiles(&sources, &[_][]const u8{
    //     "-O2",
    // });
    lib.addCSourceFiles(.{ .flags = &.{"-O2"}, .files = &sources });

    b.installArtifact(lib);
}

pub fn addPaths(step: *std.build.CompileStep) void {
    step.addIncludePath(.{ .path = sdkPath("/include") });
    step.addIncludePath(.{ .path = "src/vm" });
    step.addIncludePath(.{ .path = "src/optional" });
}

fn sdkPath(comptime suffix: []const u8) []const u8 {
    if (suffix[0] != '/') @compileError("suffix must be an absolute path");
    return comptime blk: {
        const root_dir = std.fs.path.dirname(@src().file) orelse ".";
        break :blk root_dir ++ suffix;
    };
}
