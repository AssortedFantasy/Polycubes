const std = @import("std");
const clap = @import("clap");

const testing = std.testing;
const debug = std.debug;
const DynamicBitSetUnmanaged = std.bit_set.DynamicBitSetUnmanaged;
const mem = std.mem;

const builtin = @import("builtin");

// An encoding of a Polycube.
const Polycube = struct {
    // We don't need the encoding to be overly efficient.
    // We just want it to be fast.
    blocks: []Block,
    pub const Block = [3]i8;
    const Self = @This();

    pub fn deinit(self: *Self, alloc: mem.Allocator) void {
        alloc.free(self.blocks);
        self.blocks = undefined;
    }

    pub fn duplicate(self: *const Self, alloc: mem.Allocator) !Polycube {
        return .{
            .blocks = try alloc.dupe(Block, self.blocks),
        };
    }

    fn blockCmp(_: void, lhs: Block, rhs: Block) bool {
        // Lexicographic.
        if (lhs[0] < rhs[0]) return true;
        if (lhs[0] > rhs[0]) return false;
        if (lhs[1] < rhs[1]) return true;
        if (lhs[1] > rhs[1]) return false;
        if (lhs[2] < rhs[2]) return true;
        return false; // Equal or greater.
    }

    /// Will normalize if not in normal form
    /// Normal form is where the first block is [0, 0, 0] and
    /// blocks are lexicographically sorted.
    pub fn normalize(self: *Self) void {
        std.sort.pdq(Block, self.blocks, {}, blockCmp);
        // If the first value isn't [0, 0, 0] translate everything to fix it.
        // Translations do not change lexicographic ordering.
        const fBlock = self.blocks[0];
        if (!std.meta.eql(fBlock, .{ 0, 0, 0 })) {
            for (self.blocks) |*b| {
                b[0] -= fBlock[0];
                b[1] -= fBlock[1];
                b[2] -= fBlock[2];
            }
        }
    }

    // Only valid for equal lengths.
    pub fn cubeCmp(self: *const Self, other: *const Self) bool {
        for (self.blocks, other.blocks) |b1, b2| {
            if (b1[0] < b2[0]) return true;
            if (b1[0] > b2[0]) return false;
            if (b1[1] < b2[1]) return true;
            if (b1[1] > b2[1]) return false;
            if (b1[2] < b2[2]) return true;
            if (b1[2] > b2[2]) return false;
        }
        return false;
    }
};

pub fn getDecendents() void {}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    _ = alloc;
    defer _ = gpa.deinit();

    // const params = comptime clap.parseParamsComptime(
    //     \\-h, --help        Display this help and exit.
    // );

    // var res = clap.parse(clap.Help, &params, clap.parsers.default, .{ .allocator = alloc }) catch {
    //     std.debug.print("{s}", .{"Invalid Arguments, try --help -h\n"});
    //     return;
    // };
    // defer res.deinit();

    // if (res.args.help != 0) {
    //     std.debug.print("{s}", .{"Help!\n"});
    // }
}

test "Normalize" {
    var blocks = [_]Polycube.Block{
        .{ 3, 3, 3 },
        .{ 2, 2, 2 },
        .{ 4, 4, 4 },
        .{ 1, 1, 1 },
    };

    var testBlock = Polycube{
        .blocks = &blocks,
    };
    testBlock.normalize();
    for (blocks, 0..) |b, i| {
        const iu: i8 = @intCast(i);
        try testing.expectEqual(b, .{ iu, iu, iu });
        //std.debug.print("\n{}: {any}", .{ i, b });
    }
}
