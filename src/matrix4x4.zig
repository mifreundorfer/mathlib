const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;
const assert = std.debug.assert;

const Vector4 = @import("vector4.zig").Vector4;
const Vector3 = @import("vector3.zig").Vector3;

usingnamespace @import("math.zig");

/// A 4 by 4 matrix with column major memory layout.
pub const Matrix4x4 = packed struct {
    m00: f32,
    m01: f32,
    m02: f32,
    m03: f32,
    m10: f32,
    m11: f32,
    m12: f32,
    m13: f32,
    m20: f32,
    m21: f32,
    m22: f32,
    m23: f32,
    m30: f32,
    m31: f32,
    m32: f32,
    m33: f32,

    /// Initialize the matrix with scalar values.
    /// Arguments are arranged so they are a visual representation of the matrix.
    pub fn init(
        m00: f32, m10: f32, m20: f32, m30: f32,
        m01: f32, m11: f32, m21: f32, m31: f32,
        m02: f32, m12: f32, m22: f32, m32: f32,
        m03: f32, m13: f32, m23: f32, m33: f32) Matrix4x4 {

        return .{
            .m00 = m00, .m10 = m10, .m20 = m20, .m30 = m30,
            .m01 = m01, .m11 = m11, .m21 = m21, .m31 = m31,
            .m02 = m02, .m12 = m12, .m22 = m22, .m32 = m32,
            .m03 = m03, .m13 = m13, .m23 = m23, .m33 = m33,
        };
    }

    /// Initialize the matrix from column vectors.
    pub fn initColumns(c0: Vector4, c1: Vector4, c2: Vector4, c3: Vector4) Matrix4x4 {
        return .{
            .m00 = c0.x, .m10 = c1.x, .m20 = c2.x, .m30 = c3.x,
            .m01 = c0.y, .m11 = c1.y, .m21 = c2.y, .m31 = c3.y,
            .m02 = c0.z, .m12 = c1.z, .m22 = c2.z, .m32 = c3.z,
            .m03 = c0.w, .m13 = c1.w, .m23 = c2.w, .m33 = c3.w,
        };
    }

    /// Create an identity matrix.
    pub fn identity() Matrix4x4 {
        return .{
            .m00 = 1, .m10 = 0, .m20 = 0, .m30 = 0,
            .m01 = 0, .m11 = 1, .m21 = 0, .m31 = 0,
            .m02 = 0, .m12 = 0, .m22 = 1, .m32 = 0,
            .m03 = 0, .m13 = 0, .m23 = 0, .m33 = 1,
        };
    }

    /// Return the column at index. Index must be in range [0, 3].
    pub fn column(self: Matrix4x4, index: usize) Vector4 {
        assert(index >= 0 and index < 4);
        return @ptrCast([*]const Vector4, &self.m00)[index];
    }

    /// Return a pointer to the column at index. Index must be in range [0, 3].
    pub fn columnPtr(self: *Matrix4x4, index: usize) *Vector4 {
        assert(index >= 0 and index < 4);
        return @ptrCast(*Vector4, @ptrCast([*]Vector4, &self.m00) + index);
    }

    /// Transpose a matrix
    pub fn transpose(a: Matrix4x4) Matrix4x4 {
        const ac0 = a.column(0);
        const ac1 = a.column(1);
        const ac2 = a.column(2);
        const ac3 = a.column(3);

        const c0 = Vector4.init(ac0.x, ac1.x, ac2.x, ac3.x);
        const c1 = Vector4.init(ac0.y, ac1.y, ac2.y, ac3.y);
        const c2 = Vector4.init(ac0.z, ac1.z, ac2.z, ac3.z);
        const c3 = Vector4.init(ac0.w, ac1.w, ac2.w, ac3.w);

        return initColumns(c0, c1, c2, c3);
    }

    /// Multiply two matrices.
    pub fn multiply(a: Matrix4x4, b: Matrix4x4) Matrix4x4 {
        const ac0 = a.column(0);
        const ac1 = a.column(1);
        const ac2 = a.column(2);
        const ac3 = a.column(3);

        const c0 = ac0.multiply(Vector4.set(b.m00))
              .add(ac1.multiply(Vector4.set(b.m01)))
              .add(ac2.multiply(Vector4.set(b.m02)))
              .add(ac3.multiply(Vector4.set(b.m03)));

        const c1 = ac0.multiply(Vector4.set(b.m10))
              .add(ac1.multiply(Vector4.set(b.m11)))
              .add(ac2.multiply(Vector4.set(b.m12)))
              .add(ac3.multiply(Vector4.set(b.m13)));

        const c2 = ac0.multiply(Vector4.set(b.m20))
              .add(ac1.multiply(Vector4.set(b.m21)))
              .add(ac2.multiply(Vector4.set(b.m22)))
              .add(ac3.multiply(Vector4.set(b.m23)));

        const c3 = ac0.multiply(Vector4.set(b.m30))
              .add(ac1.multiply(Vector4.set(b.m31)))
              .add(ac2.multiply(Vector4.set(b.m32)))
              .add(ac3.multiply(Vector4.set(b.m33)));

        return initColumns(c0, c1, c2, c3);
    }

    /// Multiply a matrix by a vector
    pub fn multiplyVector(a: Matrix4x4, b: Vector4) Vector4 {
        const ac0 = a.column(0);
        const ac1 = a.column(1);
        const ac2 = a.column(2);
        const ac3 = a.column(3);

        return ac0.multiply(Vector4.set(b.x))
          .add(ac1.multiply(Vector4.set(b.y)))
          .add(ac2.multiply(Vector4.set(b.z)))
          .add(ac3.multiply(Vector4.set(b.w)));
    }

    /// Create a matrix containing a translation
    pub fn createTranslation(translation: Vector3) Matrix4x4 {
        return .{
            .m00 = 1, .m10 = 0, .m20 = 0, .m30 = translation.x,
            .m01 = 0, .m11 = 1, .m21 = 0, .m31 = translation.y,
            .m02 = 0, .m12 = 0, .m22 = 1, .m32 = translation.z,
            .m03 = 0, .m13 = 0, .m23 = 0, .m33 = 1,
        };
    }

    /// Create a matrix containing a rotation around the x axis
    pub fn createRotationX(angle: f32) Matrix4x4 {
        const cs = std.math.cos(angle);
        const sn = std.math.sin(angle);

        return .{
            .m00 = 1, .m10 = 0, .m20 = 0, .m30 = 0,
            .m01 = 0, .m11 = cs, .m21 = -sn, .m31 = 0,
            .m02 = 0, .m12 = sn, .m22 = cs, .m32 = 0,
            .m03 = 0, .m13 = 0, .m23 = 0, .m33 = 1,
        };
    }

    /// Create a matrix containing a rotation around the y axis
    pub fn createRotationY(angle: f32) Matrix4x4 {
        const cs = std.math.cos(angle);
        const sn = std.math.sin(angle);

        return .{
            .m00 = cs, .m10 = 0, .m20 = sn, .m30 = 0,
            .m01 = 0, .m11 = 1, .m21 = 0, .m31 = 0,
            .m02 = -sn, .m12 = 0, .m22 = cs, .m32 = 0,
            .m03 = 0, .m13 = 0, .m23 = 0, .m33 = 1,
        };
    }

    /// Create a matrix containing a rotation around the z axis
    pub fn createRotationZ(angle: f32) Matrix4x4 {
        const cs = std.math.cos(angle);
        const sn = std.math.sin(angle);

        return .{
            .m00 = cs, .m10 = -sn, .m20 = 0, .m30 = 0,
            .m01 = sn, .m11 = cs, .m21 = 0, .m31 = 0,
            .m02 = 0, .m12 = 0, .m22 = 1, .m32 = 0,
            .m03 = 0, .m13 = 0, .m23 = 0, .m33 = 1,
        };
    }

    /// Create a matrix containing a scale
    pub fn createScale(scale: Vector3) Matrix4x4 {
        return .{
            .m00 = scale.x, .m10 = 0, .m20 = 0, .m30 = 0,
            .m01 = 0, .m11 = scale.y, .m21 = 0, .m31 = 0,
            .m02 = 0, .m12 = 0, .m22 = scale.z, .m32 = 0,
            .m03 = 0, .m13 = 0, .m23 = 0, .m33 = 1,
        };
    }

    /// Create a projection matrix with the field of view given along the vertical axis
    pub fn createPerspectiveProjectionVertical(vertical_fov: f32, aspect: f32, near: f32, far: f32, invert_depth: bool) Matrix4x4 {
        assert(vertical_fov > 0);
        assert(aspect > 0);

        const h = std.math.tan(vertical_fov * 0.5);
        const w = h * aspect;

        var z: f32 = -1;
        if (invert_depth) {
            var tmp = near;
            near = far;
            far = tmp;
            z = 1;
        }

        return .{
            .m00 = 1.0/w, .m10 = 0,     .m20 = 0,                  .m30 = 0,
            .m01 = 0,     .m11 = 1.0/h, .m21 = 0,                  .m31 = 0,
            .m02 = 0,     .m12 = 0,     .m22 = far / (near - far), .m32 = (far * near) / (near - far),
            .m03 = 0,     .m13 = 0,     .m23 = z,                  .m33 = 0,
        };
    }

    /// Create a projection matrix with the field of view given along the horizontal axis
    pub fn createPerspectiveProjectionHorizontal(horizontal_fov: f32, aspect: f32, near: f32, far: f32, invert_depth: bool) Matrix4x4 {
        assert(horizontal_fov > 0);
        assert(aspect > 0);

        const w = std.math.tan(horizontal_fov * 0.5);
        const h = w / aspect;

        var z: f32 = -1;
        if (invert_depth) {
            var tmp = near;
            near = far;
            far = tmp;
            z = 1;
        }

        return .{
            .m00 = 1.0/w, .m10 = 0,     .m20 = 0,                  .m30 = 0,
            .m01 = 0,     .m11 = 1.0/h, .m21 = 0,                  .m31 = 0,
            .m02 = 0,     .m12 = 0,     .m22 = far / (near - far), .m32 = (far * near) / (near - far),
            .m03 = 0,     .m13 = 0,     .m23 = z,                  .m33 = 0,
        };
    }

    /// Create a projection matrix with the field of view given along the shortest axis
    pub fn createPerspectiveProjectionShortest(fov: f32, aspect: f32, near: f32, far: f32, invert_depth: bool) Matrix4x4 {
        assert(fov > 0);
        assert(aspect > 0);

        var w: f32 = undefined;
        var h: f32 = undefined;

        if (aspect < 1) {
            w = std.math.tan(fov * 0.5);
            h = w / aspect;
        } else {
            h = std.math.tan(fov * 0.5);
            w = h * aspect;
        }

        var z: f32 = -1;
        if (invert_depth) {
            var tmp = near;
            near = far;
            far = tmp;
            z = 1;
        }

        return .{
            .m00 = 1.0/w, .m10 = 0,     .m20 = 0,                  .m30 = 0,
            .m01 = 0,     .m11 = 1.0/h, .m21 = 0,                  .m31 = 0,
            .m02 = 0,     .m12 = 0,     .m22 = far / (near - far), .m32 = (far * near) / (near - far),
            .m03 = 0,     .m13 = 0,     .m23 = z,                  .m33 = 0,
        };
    }

    pub fn createTransform(translation: Vector3, rotation: Quaternion, scale: Vector3) Matrix4x4 {
        const xx = 2 * rotation.x * rotation.x;
        const xy = 2 * rotation.x * rotation.y;
        const xz = 2 * rotation.x * rotation.z;
        const xw = 2 * rotation.x * rotation.w;
        const yy = 2 * rotation.y * rotation.y;
        const yz = 2 * rotation.y * rotation.z;
        const yw = 2 * rotation.y * rotation.w;
        const zz = 2 * rotation.z * rotation.z;
        const zw = 2 * rotation.z * rotation.w;

        var x_basis = Vector4.init(
            1 - yy - zz,
                xy + zw,
                xz - yw,
            0
        );

        var y_basis = Vector4.init(
                xy - zw,
            1 - xx - zz,
                yz + xw,
            0
        );

        var z_basis = Vector4.init(
                xz + yw,
                yz - xw,
            1 - xx - yy,
            0
        );

        x_basis = x_basis.multiplyScalar(scale.x);
        y_basis = x_basis.multiplyScalar(scale.y);
        z_basis = x_basis.multiplyScalar(scale.z);

        var offset = Vector4.init(translation.x, translation.y, translation.z, 1);

        return initColumns(x_basis, y_basis, z_basis, offset);
    }
};

fn expectAppproxEq(expected: Vector4, actual: Vector4) !void {
    const structType = @typeInfo(@TypeOf(actual)).Struct;

    inline for (structType.fields) |field| {
        try expectApproxEqRel(@field(expected, field.name), @field(actual, field.name), 0.00001);
    }
}

test "Matrix4x4" {
    var m: Matrix4x4 = undefined;
    var v: Vector4 = undefined;

    var m1 = Matrix4x4.init(
        1, 5, 9, 13,
        2, 6, 10, 14,
        3, 7, 11, 15,
        4, 8, 12, 16);

    var m2 = Matrix4x4.init(
        17, 21, 25, 29,
        18, 22, 26, 30,
        19, 23, 27, 31,
        20, 24, 28, 32);

    var v1 = Vector4.init(1, 2, 3, 4);

    m = Matrix4x4.init(
        1, 5, 9, 13,
        2, 6, 10, 14,
        3, 7, 11, 15,
        4, 8, 12, 16);

    try expectEqual(@as(f32,  1), m.m00);
    try expectEqual(@as(f32,  2), m.m01);
    try expectEqual(@as(f32,  3), m.m02);
    try expectEqual(@as(f32,  4), m.m03);
    try expectEqual(@as(f32,  5), m.m10);
    try expectEqual(@as(f32,  6), m.m11);
    try expectEqual(@as(f32,  7), m.m12);
    try expectEqual(@as(f32,  8), m.m13);
    try expectEqual(@as(f32,  9), m.m20);
    try expectEqual(@as(f32, 10), m.m21);
    try expectEqual(@as(f32, 11), m.m22);
    try expectEqual(@as(f32, 12), m.m23);
    try expectEqual(@as(f32, 13), m.m30);
    try expectEqual(@as(f32, 14), m.m31);
    try expectEqual(@as(f32, 15), m.m32);
    try expectEqual(@as(f32, 16), m.m33);

    try expectEqual(Vector4.init( 1,  2,  3,  4), m.column(0));
    try expectEqual(Vector4.init( 5,  6,  7,  8), m.column(1));
    try expectEqual(Vector4.init( 9, 10, 11, 12), m.column(2));
    try expectEqual(Vector4.init(13, 14, 15, 16), m.column(3));

    try expectEqual(Vector4.init( 1,  2,  3,  4), m.columnPtr(0).*);
    try expectEqual(Vector4.init( 5,  6,  7,  8), m.columnPtr(1).*);
    try expectEqual(Vector4.init( 9, 10, 11, 12), m.columnPtr(2).*);
    try expectEqual(Vector4.init(13, 14, 15, 16), m.columnPtr(3).*);


    m = Matrix4x4.initColumns(
        Vector4.init(1, 2, 3, 4),
        Vector4.init(5, 6, 7, 8),
        Vector4.init(9, 10, 11, 12),
        Vector4.init(13, 14, 15, 16));

    try expectEqual(@as(f32,  1), m.m00);
    try expectEqual(@as(f32,  2), m.m01);
    try expectEqual(@as(f32,  3), m.m02);
    try expectEqual(@as(f32,  4), m.m03);
    try expectEqual(@as(f32,  5), m.m10);
    try expectEqual(@as(f32,  6), m.m11);
    try expectEqual(@as(f32,  7), m.m12);
    try expectEqual(@as(f32,  8), m.m13);
    try expectEqual(@as(f32,  9), m.m20);
    try expectEqual(@as(f32, 10), m.m21);
    try expectEqual(@as(f32, 11), m.m22);
    try expectEqual(@as(f32, 12), m.m23);
    try expectEqual(@as(f32, 13), m.m30);
    try expectEqual(@as(f32, 14), m.m31);
    try expectEqual(@as(f32, 15), m.m32);
    try expectEqual(@as(f32, 16), m.m33);


    m = Matrix4x4.transpose(m1);
    try expectEqual(
        Matrix4x4.init(
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 10, 11, 12,
            13, 14, 15, 16
        ), m);


    m = Matrix4x4.identity();
    try expectEqual(
        Matrix4x4.init(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
        ), m);


    m = m1.multiply(m2);
    try expectEqual(
        Matrix4x4.init(
            538, 650, 762, 874,
            612, 740, 868, 996,
            686, 830, 974, 1118,
            760, 920, 1080, 1240
        ), m);


    v = m1.multiplyVector(v1);
    try expectEqual(v, Vector4.init(90, 100, 110, 120));


    m = Matrix4x4.createTranslation(Vector3.init(1, 2, 3));
    try expectEqual(
        Matrix4x4.init(
            1, 0, 0, 1,
            0, 1, 0, 2,
            0, 0, 1, 3,
            0, 0, 0, 1,
        ), m);

    v = Matrix4x4.createTranslation(Vector3.init(1, -2, 3)).multiplyVector(Vector4.init(1, 2, 3, 1));
    try expectEqual(Vector4.init(2, 0, 6, 1), v);

    v = Matrix4x4.createRotationX(degToRad(@as(f32, 90))).multiplyVector(Vector4.init(1, 2, 3, 1));
    try expectAppproxEq(Vector4.init(1, -3, 2, 1), v);

    v = Matrix4x4.createRotationX(degToRad(@as(f32, -90))).multiplyVector(Vector4.init(1, 2, 3, 1));
    try expectAppproxEq(Vector4.init(1, 3, -2, 1), v);

    v = Matrix4x4.createRotationY(degToRad(@as(f32, 90))).multiplyVector(Vector4.init(1, 2, 3, 1));
    try expectAppproxEq(Vector4.init(3, 2, -1, 1), v);

    v = Matrix4x4.createRotationY(degToRad(@as(f32, -90))).multiplyVector(Vector4.init(1, 2, 3, 1));
    try expectAppproxEq(Vector4.init(-3, 2, 1, 1), v);

    v = Matrix4x4.createRotationZ(degToRad(@as(f32, 90))).multiplyVector(Vector4.init(1, 2, 3, 1));
    try expectAppproxEq(Vector4.init(-2, 1, 3, 1), v);

    v = Matrix4x4.createRotationZ(degToRad(@as(f32, -90))).multiplyVector(Vector4.init(1, 2, 3, 1));
    try expectAppproxEq(Vector4.init(2, -1, 3, 1), v);

    m = Matrix4x4.createScale(Vector3.init(-1, 2, 3));
    try expectEqual(
        Matrix4x4.init(
            -1, 0, 0, 0,
            0, 2, 0, 0,
            0, 0, 3, 0,
            0, 0, 0, 1,
        ), m);
}