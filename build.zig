const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "wren",
        .target = target,
        .optimize = optimize,
    });

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

    lib.addIncludePath("src/include");
    lib.addIncludePath("src/vm");
    lib.addIncludePath("src/optional");
    lib.addCSourceFiles(&sources, &[_][]const u8{
        "-O2",
    });
    lib.linkLibC();
    lib.installHeadersDirectory("src/include", "");

    b.installArtifact(lib);
}
