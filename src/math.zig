const std = @import("std");

const testing = std.testing;
const expectApproxEqRel = testing.expectApproxEqRel;
const assert = std.debug.assert;

/// Convert radians to degrees.
pub fn radToDeg(radians: anytype) @TypeOf(radians) {
    assert(@typeInfo(@TypeOf(radians)) == .Float);

    return radians * (360.0 / std.math.tau);
}

test "radToDeg" {
    try expectApproxEqRel(@as(f32, 360.0), radToDeg(@as(f32, std.math.tau)), 0.00001);
    try expectApproxEqRel(@as(f32, 180.0), radToDeg(@as(f32, std.math.pi)), 0.00001);
    try expectApproxEqRel(@as(f32, 90.0), radToDeg(@as(f32, std.math.pi / 2.0)), 0.00001);
}

/// Convert degress to radians.
pub fn degToRad(degrees: anytype) @TypeOf(degrees) {
    assert(@typeInfo(@TypeOf(degrees)) == .Float);

    return degrees * (std.math.tau / 360.0);
}

test "degToRad" {
    try expectApproxEqRel(@as(f32, std.math.tau), degToRad(@as(f32, 360.0)), 0.00001);
    try expectApproxEqRel(@as(f32, std.math.pi), degToRad(@as(f32, 180.0)), 0.00001);
    try expectApproxEqRel(@as(f32, std.math.pi / 2.0), degToRad(@as(f32, 90.0)), 0.00001);
}