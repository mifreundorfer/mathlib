const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

pub const Vector4 = packed struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,

    pub fn init(x: f32, y: f32, z: f32, w: f32) Vector4 {
        return .{ .x = x, .y = y, .z = z, .w = w };
    }

    pub fn set(value: f32) Vector4 {
        return .{ .x = value, .y = value, .z = value, .w = value };
    }

    pub fn normalize(v: Vector4) Vector4 {
        return multiplyScalar(v, 1.0 / length(v));
    }

    pub fn length(v: Vector4) f32 {
        return std.math.sqrt(dot(v, v));
    }

    pub fn squaredLength(v: Vector4) f32 {
        return dot(v, v);
    }

    pub fn dot(a: Vector4, b: Vector4) f32 {
        return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
    }

    pub fn add(a: Vector4, b: Vector4) Vector4 {
        return init(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w);
    }

    pub fn subtract(a: Vector4, b: Vector4) Vector4 {
        return init(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w);
    }

    pub fn multiply(a: Vector4, b: Vector4) Vector4 {
        return init(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w);
    }

    pub fn divide(a: Vector4, b: Vector4) Vector4 {
        return init(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w);
    }

    pub fn addScalar(a: Vector4, b: f32) Vector4 {
        return init(a.x + b, a.y + b, a.z + b, a.w + b);
    }

    pub fn subtractScalar(a: Vector4, b: f32) Vector4 {
        return init(a.x - b, a.y - b, a.z - b, a.w - b);
    }

    pub fn multiplyScalar(a: Vector4, b: f32) Vector4 {
        return init(a.x * b, a.y * b, a.z * b, a.w * b);
    }

    pub fn divideScalar(a: Vector4, b: f32) Vector4 {
        return init(a.x / b, a.y / b, a.z / b, a.w / b);
    }
};

test "Vector4" {
    var v1 = Vector4.init(1, 2, 3, 4);
    var v2 = Vector4.init(5, 6, 7, 8);
    var v: Vector4 = undefined;
    var s: f32 = undefined;

    v = Vector4.init(1, 2, 3, 4);
    try expectEqual(@as(f32, 1.0), v.x);
    try expectEqual(@as(f32, 2.0), v.y);
    try expectEqual(@as(f32, 3.0), v.z);
    try expectEqual(@as(f32, 4.0), v.w);

    v = Vector4.set(4);
    try expectEqual(@as(f32, 4.0), v.x);
    try expectEqual(@as(f32, 4.0), v.y);
    try expectEqual(@as(f32, 4.0), v.z);
    try expectEqual(@as(f32, 4.0), v.w);

    v = v1.add(v2);
    try expectEqual(Vector4.init(6, 8, 10, 12), v);

    v = v1.addScalar(14);
    try expectEqual(Vector4.init(15, 16, 17, 18), v);

    v = v1.subtract(v2);
    try expectEqual(Vector4.init(-4, -4, -4, -4), v);

    v = v1.subtractScalar(-4);
    try expectEqual(Vector4.init(5, 6, 7, 8), v);

    v = v1.multiply(v2);
    try expectEqual(Vector4.init(5, 12, 21, 32), v);

    v = v1.multiplyScalar(-4);
    try expectEqual(Vector4.init(-4, -8, -12, -16), v);

    v = v1.divide(v2);
    try expectApproxEqRel(@as(f32, 1.0/5.0), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/6.0), v.y, 0.0001);
    try expectApproxEqRel(@as(f32, 3.0/7.0), v.z, 0.0001);
    try expectApproxEqRel(@as(f32, 4.0/8.0), v.w, 0.0001);

    v = v1.divideScalar(2);
    try expectApproxEqRel(@as(f32, 1.0/2.0), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/2.0), v.y, 0.0001);
    try expectApproxEqRel(@as(f32, 3.0/2.0), v.z, 0.0001);
    try expectApproxEqRel(@as(f32, 4.0/2.0), v.w, 0.0001);

    s = Vector4.dot(v1, v2);
    try expectApproxEqRel(@as(f32, 70.0), s, 0.0001);

    s = Vector4.squaredLength(v1);
    try expectApproxEqRel(@as(f32, 30.0), s, 0.0001);

    s = Vector4.length(v1);
    try expectApproxEqRel(@as(f32, 5.477), s, 0.0001);

    v = Vector4.normalize(v1);
    try expectApproxEqRel(@as(f32, 1.0/5.477), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/5.477), v.y, 0.0001);
    try expectApproxEqRel(@as(f32, 3.0/5.477), v.z, 0.0001);
    try expectApproxEqRel(@as(f32, 4.0/5.477), v.w, 0.0001);
}