const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

pub const Vector2Int = packed struct {
    x: i32,
    y: i32,

    pub fn init(x: i32, y: i32) Vector2Int {
        return .{ .x = x, .y = y };
    }

    pub fn set(value: i32) Vector2Int {
        return .{ .x = value, .y = value };
    }

    pub fn add(a: Vector2Int, b: Vector2Int) Vector2Int {
        return init(a.x + b.x, a.y + b.y);
    }

    pub fn subtract(a: Vector2Int, b: Vector2Int) Vector2Int {
        return init(a.x - b.x, a.y - b.y);
    }

    pub fn multiply(a: Vector2Int, b: Vector2Int) Vector2Int {
        return init(a.x * b.x, a.y * b.y);
    }

    pub fn divideTrunc(a: Vector2Int, b: Vector2Int) Vector2Int {
        return init(@divTrunc(a.x, b.x), @divTrunc(a.y, b.y));
    }

    pub fn addScalar(a: Vector2Int, b: i32) Vector2Int {
        return init(a.x + b, a.y + b);
    }

    pub fn subtractScalar(a: Vector2Int, b: i32) Vector2Int {
        return init(a.x - b, a.y - b);
    }

    pub fn multiplyScalar(a: Vector2Int, b: i32) Vector2Int {
        return init(a.x * b, a.y * b);
    }

    pub fn divideScalarTrunc(a: Vector2Int, b: i32) Vector2Int {
        return init(@divTrunc(a.x, b), @divTrunc(a.y, b));
    }
};

test "Vector2Int" {
    var v1 = Vector2Int.init(1, 2);
    var v2 = Vector2Int.init(5, 6);
    var v: Vector2Int = undefined;

    v = Vector2Int.init(1, 2);
    try expectEqual(@as(i32, 1.0), v.x);
    try expectEqual(@as(i32, 2.0), v.y);

    v = Vector2Int.set(4);
    try expectEqual(@as(i32, 4.0), v.x);
    try expectEqual(@as(i32, 4.0), v.y);

    v = v1.add(v2);
    try expectEqual(Vector2Int.init(6, 8), v);

    v = v1.addScalar(14);
    try expectEqual(Vector2Int.init(15, 16), v);

    v = v1.subtract(v2);
    try expectEqual(Vector2Int.init(-4, -4), v);

    v = v1.subtractScalar(-4);
    try expectEqual(Vector2Int.init(5, 6), v);

    v = v1.multiply(v2);
    try expectEqual(Vector2Int.init(5, 12), v);

    v = v1.multiplyScalar(-4);
    try expectEqual(Vector2Int.init(-4, -8), v);

    v = v2.divideTrunc(v1);
    try expectEqual(Vector2Int.init(5, 3), v);

    v = v2.divideScalarTrunc(2);
    try expectEqual(Vector2Int.init(2, 3), v);
}