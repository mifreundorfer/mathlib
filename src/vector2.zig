const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

pub const Vector2 = packed struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vector2 {
        return .{ .x = x, .y = y };
    }

    pub fn set(value: f32) Vector2 {
        return .{ .x = value, .y = value };
    }

    pub fn normalize(v: Vector2) Vector2 {
        return multiplyScalar(v, 1.0 / length(v));
    }

    pub fn length(v: Vector2) f32 {
        return std.math.sqrt(dot(v, v));
    }

    pub fn squaredLength(v: Vector2) f32 {
        return dot(v, v);
    }

    pub fn dot(a: Vector2, b: Vector2) f32 {
        return a.x * b.x + a.y * b.y;
    }

    pub fn add(a: Vector2, b: Vector2) Vector2 {
        return init(a.x + b.x, a.y + b.y);
    }

    pub fn subtract(a: Vector2, b: Vector2) Vector2 {
        return init(a.x - b.x, a.y - b.y);
    }

    pub fn multiply(a: Vector2, b: Vector2) Vector2 {
        return init(a.x * b.x, a.y * b.y);
    }

    pub fn divide(a: Vector2, b: Vector2) Vector2 {
        return init(a.x / b.x, a.y / b.y);
    }

    pub fn addScalar(a: Vector2, b: f32) Vector2 {
        return init(a.x + b, a.y + b);
    }

    pub fn subtractScalar(a: Vector2, b: f32) Vector2 {
        return init(a.x - b, a.y - b);
    }

    pub fn multiplyScalar(a: Vector2, b: f32) Vector2 {
        return init(a.x * b, a.y * b);
    }

    pub fn divideScalar(a: Vector2, b: f32) Vector2 {
        return init(a.x / b, a.y / b);
    }
};

test "Vector2" {
    var v1 = Vector2.init(1, 2);
    var v2 = Vector2.init(5, 6);
    var v: Vector2 = undefined;
    var s: f32 = undefined;

    v = Vector2.init(1, 2);
    try expectEqual(@as(f32, 1.0), v.x);
    try expectEqual(@as(f32, 2.0), v.y);

    v = Vector2.set(4);
    try expectEqual(@as(f32, 4.0), v.x);
    try expectEqual(@as(f32, 4.0), v.y);

    v = v1.add(v2);
    try expectEqual(Vector2.init(6, 8), v);

    v = v1.addScalar(14);
    try expectEqual(Vector2.init(15, 16), v);

    v = v1.subtract(v2);
    try expectEqual(Vector2.init(-4, -4), v);

    v = v1.subtractScalar(-4);
    try expectEqual(Vector2.init(5, 6), v);

    v = v1.multiply(v2);
    try expectEqual(Vector2.init(5, 12), v);

    v = v1.multiplyScalar(-4);
    try expectEqual(Vector2.init(-4, -8), v);

    v = v1.divide(v2);
    try expectApproxEqRel(@as(f32, 1.0/5.0), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/6.0), v.y, 0.0001);

    v = v1.divideScalar(2);
    try expectApproxEqRel(@as(f32, 1.0/2.0), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/2.0), v.y, 0.0001);

    s = Vector2.dot(v1, v2);
    try expectApproxEqRel(@as(f32, 17.0), s, 0.0001);

    s = Vector2.squaredLength(v1);
    try expectApproxEqRel(@as(f32, 5.0), s, 0.0001);

    s = Vector2.length(v1);
    try expectApproxEqRel(@as(f32, 2.236), s, 0.0001);

    v = Vector2.normalize(v1);
    try expectApproxEqRel(@as(f32, 1.0/2.236), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/2.236), v.y, 0.0001);
}