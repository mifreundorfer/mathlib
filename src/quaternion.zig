const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

pub const Quaternion = packed struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,

    pub fn init(x: f32, y: f32, z: f32, w: f32) Quaternion {
        return .{ .x = x, .y = y, .z = z, .w = w };
    }

    pub fn identity() Quaternion {
        return .{ .x = 0, .y = 0, .z = 0, .w = 1 };
    }

    pub fn normalize(q: Quaternion) Quaternion {
        const inv_length = 1.0 / length(q);
        return .{ .x = q.x * inv_length, .y = q.y * inv_length, .z = q.z * inv_length, .w = q.w * inv_length };
    }

    pub fn length(q: Quaternion) f32 {
        return std.math.sqrt(dot(q, q));
    }

    pub fn conjugate(q: Quaternion) Quaternion {
        return .{ .x = -q.x, .y = -q.y, .z = -q.z, .w = q.w };
    }

    pub fn dot(a: Quaternion, b: Quaternion) f32 {
        return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
    }

    pub fn multiply(a: Quaternion, b: Quaternion) Quaternion {
        return .{
            //   i * 1 = i   1 * i = i   j * k = i   k * j = -i
            .x = (a.x*b.w) + (a.w*b.x) + (a.y*b.z) - (a.z*b.y),
            //   j * 1 = j   1 * j = j   k * i = j   i * k = -j
            .y = (a.y*b.w) + (a.w*b.y) + (a.z*b.x) - (a.x*b.z),
            //   k * 1 = k   1 * k = k   i * j = k   j * i = -k
            .z = (a.z*b.w) + (a.w*b.z) + (a.x*b.y) - (a.y*b.x),
            //   1 * 1 = 1   i * i = -1  j * j = -1  k * k = -1
            .w = (a.w*b.w) - (a.x*b.x) - (a.y*b.y) - (a.z*b.z),
        };
    }

    pub fn multiplyVector(q: Quaternion, v: Vector3) Vector3 {
        const qv = Quaternion.init(v.x, v.y, v.z, 0);

        const result = q.multiply(qv).multiply(conjugate(q));

        return Vector3.init(result.x, result.y, result.z);
    }
};

test "Quaternion" {
    var q1 = Quaternion.init(1, 2, 3, 4);
    var q2 = Quaternion.init(5, 6, 7, 8);
    var v: Quaternion = undefined;
    var s: f32 = undefined;

    v = Quaternion.init(1, 2, 3, 4);
    try expectEqual(@as(f32, 1.0), v.x);
    try expectEqual(@as(f32, 2.0), v.y);
    try expectEqual(@as(f32, 3.0), v.z);
    try expectEqual(@as(f32, 4.0), v.w);

    v = Quaternion.identity();
    try expectEqual(@as(f32, 0.0), v.x);
    try expectEqual(@as(f32, 0.0), v.y);
    try expectEqual(@as(f32, 0.0), v.z);
    try expectEqual(@as(f32, 1.0), v.w);

    s = Quaternion.dot(q1, q2);
    try expectApproxEqRel(@as(f32, 70.0), s, 0.0001);

    s = Quaternion.length(q1);
    try expectApproxEqRel(@as(f32, 5.477), s, 0.0001);

    v = Quaternion.normalize(q1);
    try expectApproxEqRel(@as(f32, 1.0/5.477), v.x, 0.0001);
    try expectApproxEqRel(@as(f32, 2.0/5.477), v.y, 0.0001);
    try expectApproxEqRel(@as(f32, 3.0/5.477), v.z, 0.0001);
    try expectApproxEqRel(@as(f32, 4.0/5.477), v.w, 0.0001);
}