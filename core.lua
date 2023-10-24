--[[
MIT License

Copyright (c) 2023 Graham Ranson of Glitch Games Ltd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

--- Class creation.
local Maths = {}

--- Required libraries

-- Localised functions.
local sqrt = math.sqrt
local floor = math.floor
local atan2 = math.atan2
local deg = math.deg
local rad = math.rad
local cos = math.cos
local sin = math.sin
local max = math.max
local min = math.min
local abs = math.abs

-- Localised values.

function Maths:new( params )
	
	return self
	
end

--- Gets a heading vector for an angle.
-- @param angle The angle to use, in degrees.
-- @return The heading vector.
function Maths:vectorFromAngle( angle )
	return { x = cos( rad( angle - 90 ) ), y = sin( rad( angle - 90 ) ) }
end


--- Calculates the length of a vector.
-- @param vector The vector to calculate..
-- @return The length.
function Maths:lengthOfVector( vector )
	local d = max ( abs( vector.x ), abs( vector.y ) )
	local n = min( abs( vector.x ), abs( vector.y ) ) / d
	return sqrt( n * n + 1 ) * d
end

--- Gets the angle between two position vectors.
-- @param vector1 The first position.
-- @param vector2 The second position.
-- @return The angle.
function Maths:angleBetweenVectors( vector1, vector2 )
	if vector1 and vector2 then
		local angle = deg( atan2( vector2.y - vector1.y, vector2.x - vector1.x ) ) + 90
		if angle < 0 then angle = 360 + angle end
		return angle
	end
end

--- Gets the difference between two position angles.
-- @param angle1 The first angle.
-- @param angle2 The second angle.
-- @return The difference.
function Maths:differenceBetweenAngles( angle1, angle2 )

	local d = angle1 - angle2
	d = ( d + 180 ) % 360 - 180

	return d

end

--- Gets the distance between two position vectors.
-- @param vector1 The first position.
-- @param vector2 The second position.
-- @return The distance.
function Maths:distanceBetweenVectors( vector1, vector2 )
	if not vector1 or not vector1.x or not vector1.y or not vector2 or not vector2.x or not vector2.y then
		return
	end
	return sqrt( self:distanceBetweenVectorsSquared( vector1, vector2 ) )
end

--- Gets the squared distance between two position vectors.
-- @param vector1 The first position.
-- @param vector2 The second position.
-- @return The distance.
function Maths:distanceBetweenVectorsSquared( vector1, vector2 )
	if not vector1 or not vector1.x or not vector1.y or not vector2 or not vector2.x or not vector2.y then
		return
	end
	local factor = { x = vector2.x - vector1.x, y = vector2.y - vector1.y }
	return ( factor.x * factor.x ) + ( factor.y * factor.y )
end

--- Normalises a value to within 0 and 1.
-- @param value The current unnormalised value.
-- @param min The minimum the value can be.
-- @param max The maximum the value can be.
-- @return The newly normalised value.
function Maths:normalise( value, min, max )
	local result = ( value - min ) / ( max - min )
	if result > 1 then
		result = 1
	end
	return result
end

--- Rounds a number.
-- @param number The number to round.
-- @param idp The number of decimal places to round to. Optional, defaults to 0.
-- @return The rounded number.
function Maths:round( number, idp )
	if number then
		local mult = 10 ^ ( idp or 0 )
		return floor( number * mult + 0.5 ) / mult
	end
end

function Maths:getPointAlongLine( vector1, vector2, distance )
	   local angle = math.atan2( vector2.y - vector1.y, vector2.x - vector1.x )
	   local dx = math.cos( angle )
	   local dy = math.sin( angle )
	   return { x = vector2.x + dx * distance, y = vector2.y + dy * distance }
   end
   
--- Normalises a value from one range to another so that it's within within 0 and 1.
-- @param value The current value.
-- @param minA The minimum the value can be on the first range.
-- @param maxA The maximum the value can be on the first range.
-- @param minB The minimum the value can be on the second range.
-- @param maxB The maximum the value can be on the second range.
-- @return The newly normalised value.
function Maths:normaliseAcrossRanges( value, minA, maxA, minB, maxB )
	return ( ( ( value - minA ) * ( maxB - minB ) ) / ( maxA - minA ) ) + minB
end


--- Gets the centre point between two position vectors.
-- @param vector1 The first position.
-- @param vector2 The second position.
-- @return The centre position as a table containing x and y values.
function Maths:centreBetweenVectors( vector1, vector2 )

	return
	{
		x = ( vector1.x + vector2.x ) * 0.5,
		y = ( vector1.y + vector2.y ) * 0.5
	}

end

--- Checks if a point is within a given polygon.
-- @param x The X position of the point.
-- @param y The Y position of the point.
-- @param The vertices of the polygon.
-- @return True if it is, false otherwise.
function Maths:pointInPolygon( x, y, vertices )

	local intersects = false

	local j = #vertices
	for i = 1, #vertices, 1 do
		if (vertices[i][2] < y and vertices[j][2] >= y or vertices[j][2] < y and vertices[i][2] >= y) then
			if (vertices[i][1] + ( y - vertices[i][2] ) / (vertices[j][2] - vertices[i][2]) * (vertices[j][1] - vertices[i][1]) < x) then
				intersects = not intersects
			end
		end
		j = i
	end

	return intersects

end

--- Checks if a point is within a given rectangle.
-- @param x The X position of the point.
-- @param y The Y position of the point.
-- @param bounds The bounds of the rectangle.
-- @return True if it is, false otherwise.
function Maths:pointInRectangle( x, y, bounds )

	if x and y and bounds and bounds.xMin and bounds.xMax and bounds.yMin and bounds.yMax then
		if x >= bounds.xMin and x <= bounds.xMax then
			if y >= bounds.yMin and y <= bounds.yMax then
				return true
			end
		end
	end

end

--- Checks if a point is within a given rectangle.
-- @param x The X position of the point.
-- @param y The Y position of the point.
-- @param width The width of the rectangle.
-- @param height The height of the rectangle.
-- @param rotation The rotation of the rectangle. Opotional, defaults to 0.
-- @return True if it is, false otherwise.
function Maths:pointInRotatedRectangle( x, y, centre, width, height, rotation )
	return self:pointInPolygon( x, y, Scrappy.Maths:getCornersOfRotatedRectangle( centre.x, centre.y, width, height, rotation or 0 ) )
end

--- Checks if a point is within a given circle.
-- @param x The X position of the point.
-- @param y The Y position of the point.
-- @param cX The X position of the circle.
-- @param cY The Y position of the circle.
-- @param radius The radius of the circle.
-- @return True if it is, false otherwise.
function Maths:pointInCircle( x, y, cX, cY, radius )

	return self:distanceBetweenVectorsSquared( { x = cX, y = cY }, { x = x, y = y } ) <= ( radius * radius )

end

--- Checks if two circles have collided.
-- @param vector1 The position of the first circle.
-- @param vector2 The position of the second circle.
-- @param radius1 The radius of the first circle.
-- @param radius2 The radius of the second circle.
-- @return True if they have, false otherwise.
function Maths:haveCirclesCollided( vector1, vector2, radius1, radius2 )

	if not vector1 or not vector2 or not radius1 or not radius2 then
		return false
	end

	local dx = vector1.x - vector2.x
	local dy = vector1.y - vector2.y

	local distance = math.sqrt( dx * dx + dy * dy )
	local size = radius1 + radius2

	return distance < size

end

--- Checks if two bounding boxes have collided.
-- @param bounds1 The contentBounds of the first box.
-- @param bounds2 The contentBounds of the second box.
-- @return True if they have, false otherwise.
function Maths:haveRectanglesCollided( bounds1, bounds2 )

	if not bounds1 or not bounds2 then
		return false
	end

	local left = bounds1.xMin <= bounds2.xMin and bounds1.xMax >= bounds2.xMin
	local right = bounds1.xMin >= bounds2.xMin and bounds1.xMin <= bounds2.xMax
	local up = bounds1.yMin <= bounds2.yMin and bounds1.yMax >= bounds2.yMin
	local down = bounds1.yMin >= bounds2.yMin and bounds1.yMin <= bounds2.yMax

	return ( left or right ) and ( up or down )

end

--- Checks if a circle has collded with a rectangle.
-- @param circle Table containing x, y, and radius values.
-- @param bounds The contentBounds of the rectangle.
-- @return True if they have, false otherwise.
function Maths:hasCircleCollidedWithRectangle( circle, bounds )

	-- Find the closest point to the circle within the rectangle
	local closestX = self:clamp( circle.x, bounds.xMin, bounds.xMax )
	local closestY = self:clamp( circle.y, bounds.yMin, bounds.yMax )

	-- Calculate the distance between the circle's center and this closest point
	local distanceX = circle.x - closestX
	local distanceY = circle.y - closestY

	 -- If the distance is less than the circle's radius, an intersection occurs
	local distanceSquared = ( distanceX * distanceX ) + ( distanceY * distanceY )

	return distanceSquared < ( circle.radius * circle.radius )

end

--- Gets the area of a polygon.
-- @param vertices The vertices of the polygon.
-- @return The area.
function Maths:areaOfPolygon( vertices )

	local area = self:crossProduct( vertices[ #vertices ], vertices[ 1 ] )

	for i = 1, #vertices - 1, 1 do
		area = area + self:crossProduct( vertices[ i ], vertices[ i + 1 ] )
	end

	area = area / 2

	return area

end

--- Gets the centre of a polygon.
-- @param vertices The vertices of the polygon.
-- @return The centre position, a table containing 'x' and 'y' values.
function Maths:centreOfPolygon( vertices )

	local p,q = vertices[ #vertices ], vertices[ 1 ]
	local det = self:crossProduct( p, q )
	local centroid = { x = ( p.x + q.x ) * det, y = ( p.y + q.y ) * det }

	for i = 1, #vertices - 1, 1 do
		p, q = vertices[ i ], vertices[ i + 1 ]
		det = self:crossProduct( p, q )
		centroid.x = centroid.x + ( p.x + q.x ) * det
		centroid.y = centroid.y + ( p.y + q.y ) * det
	end

	local area = self:areaOfPolygon( vertices )
	centroid.x = centroid.x / ( 6 * area )
	centroid.y = centroid.y / ( 6 * area )

	return centroid

end


--- Calculate the dot product of two vectors.
-- @param v1 The first vector. An object containing both an 'x' and a 'y' property.
-- @param v2 The second vector. An object containing both an 'x' and a 'y' property.
-- @return The calculated dot product.
function Maths:dotProduct( v1, v2 )
	return v1.x * v2.x + v1.y * v2.y
end

--- Calculate the cross product of two vectors.
-- @param v1 The first vector. An object containing both an 'x' and a 'y' property.
-- @param v2 The second vector. An object containing both an 'x' and a 'y' property.
-- @return The calculated cross product.
function Maths:crossProduct( v1, v2 )
	return ( v1.x * v2.y ) - ( v1.y * v2.x )
end

--- Multiplies two vectors.
-- @param v1 The first vector. An object containing both an 'x' and a 'y' property.
-- @param v2 The second vector. An object containing both an 'x' and a 'y' property.
-- @return The resultant vector.
function Maths:vectorMultiply( v1, v2 )
	return { x = v1.x * v2.x, y = v1.y * v2.y }
end

--- Gets the magnitude of a vector.
-- @param v The vector. An object containing both an 'x' and a 'y' property.
-- @return The magnitude.
function Maths:vectorMagnitude( v )
	return sqrt( v.x * v.x + v.y * v.y )
end

--- Normalises a vector.
-- @param v The vector. An object containing both an 'x' and a 'y' property.
-- @return The normalised vector.
function Maths:vectorNormalise( v )

	local length = self:vectorMagnitude( v )

	-- Do something suitable to handle the case where the length is close to 0 here...
	return  { x = v.x / length, y = v.y / length }

end

function Maths:destroy()
	
end

return Maths