-- Exemplo 1 --
Declare @GeometryVariable Geometry
Set @GeometryVariable= Geometry::STGeomFromText('POINT(4 5)',0)
Select @GeometryVariable

-- Exemplo 2 --
Select @GeometryVariable.STX -- Retrieves the X-coordinate property of a Point instance.
Select @GeometryVariable.STY -- Retrieves the Y-coordinate property of a Point instance.
Select @GeometryVariable.Z -- Retrieves the Z value (Elevation) of a Point instance.
Select @GeometryVariable.M -- Retrieves the M value (measure) of a Point instance.

-- Exemplo 3 --
Select Geometry::Parse('POINT(4 5 6 3.5)')
Go

-- Exemplo 4 --
Declare @GeometryVariable1 Geometry='LINESTRING (1 1, 3 3)'
Select @GeometryVariable1 As 'straight line'
Go

-- Exemplo 5 --
Declare @GeometryVariable3 Geometry='LINESTRING(1 1, 3 3, 2 4, 2 0)'
Select @GeometryVariable3 As 'Complex LineString'
Go

-- Exemplo 6 --
Declare @GeometryVariable4 Geometry='LINESTRING (1 1, 3 3, 2 4, 2 0, 1 1)'
Select @GeometryVariable4 As 'Variable LineString'
Go

-- Exemplo 7 --
Declare @GeometryVariable Geometry
Set @GeometryVariable = Geometry::Parse('CIRCULARSTRING EMPTY')
Select @GeometryVariable As Empty
Go

-- Exemplo 8 --
Declare @GeometryVariable Geometry
Set @GeometryVariable = Geometry::STGeomFromText('CIRCULARSTRING(2 0, 1 1, 0 0)', 0)
Select @GeometryVariable As 'CircularString shaped like an arc'
Go

-- Exemplo 9 --
Declare @GeometryVariable2 Geometry ='CIRCULARSTRING (1 1, 2 0, -1 1)'
Select @GeometryVariable2 As CircularString
Go

-- Exemplo 10 --
Declare @GeometryVariable Geometry
Set @GeometryVariable = Geometry::Parse('CIRCULARSTRING(2 1, 1 2, 0 1, 1 0, 2 1)')
Select @GeometryVariable As CircularClosed
Go

-- Exemplo 11 --
Declare @GeometryVariable geography ='CIRCULARSTRING(-122.358 47.653, -122.348 47.649, -122.348 47.658, -122.358 47.658, -122.358 47.653)'
Select @GeometryVariable As 'Geography Latitude And Longitude'
Go

-- Exemplo 12 --
Declare @GeometryVariable2 Geometry ='COMPOUNDCURVE(CIRCULARSTRING(1 0, 0 1, -1 0), (-1 0, 1.25 0))'
Select @GeometryVariable2 As 'COMPOUNDCURVE'
Go

-- Exemplo 13 --
Declare @GeometryVariable Geometry
Set @GeometryVariable = Geometry::Parse('COMPOUNDCURVE(CIRCULARSTRING(0 2, 2 0, 4 2), CIRCULARSTRING(4 2, 2 4, 0 2))')
Select @GeometryVariable As 'CompoundCurve with multiple CircularStrings'
Go

-- Exemplo 14 --
Declare @GeometryVariable4 Geometry ='POLYGON((1 1, 3 1, 3 7, 1 7, 1 1))'
Select @GeometryVariable4 As 'Rectangular Polygon'
Go

-- Exemplo 15 --
Declare @GeometryVariable5 Geometry ='POLYGON((10 1, 10 9, 4 9, 10 1),(9 4, 9 8, 6 8, 9 4))'
Select @GeometryVariable5 As 'Triangular Polygon that contains an interior ring' 
Go

-- Exemplo 16 --
Declare @GeometryVariable2 Geometry ='POLYGON((-20 -20, -20 20, 20 20, 20 -20, -20 -20), (10 0, 0 10, 0 -10, 10 0))'
Select @GeometryVariable2 As 'Square polygon that contains a circle'
Go

-- Exemplo 17 --
Declare @GeometryVariable1 Geometry ='MultiPolygon(((2 0, 3 1, 2 2, 1.5 1.5, 2 1, 1.5 0.5, 2 0)), ((1 0, 1.5 0.5, 1 1, 1.5 1.5, 1 2, 0 1, 1 0)))'
Select @GeometryVariable1 As 'MultiPolygon'
Go

-- Exemplo 18 --
Declare @GeometryVariable1 Geometry ='CURVEPOLYGON ((4 2, 8 2, 8 6, 4 6, 4 2))'
Select @GeometryVariable1 As 'CURVEPOLYGON'
Go

-- Exemplo 19 --
Declare @GeometryVariable geography 
Set @GeometryVariable = 'CURVEPOLYGON(CIRCULARSTRING(-122.358 47.653, -122.348 47.649, -122.348 47.658, -122.358 47.658, -122.358 47.653))'
Select @GeometryVariable As 'CurvePolygon initialized with geography instance'
Go

-- Exemplo 20 --
Declare @GeometryVariable Geometry
Set @GeometryVariable = Geometry::Parse('MultiPolygon(((0 0, 0 3, 3 3, 3 0, 0 0), (1 1, 1 2, 2 1, 1 1)), ((9 9, 9 10, 10 9, 9 9)))')
Select @GeometryVariable As 'MultiPolygonwith three Polygon instances'
Go

-- Exemplo 21 --
Declare @GeometryVariable2 Geometry ='MultiPolygon(((1 1, 1 -1, -1 -1, -1 1, 1 1)),((1 1, 3 1, 3 3, 1 3, 1 1)))'
Select @GeometryVariable2 As 'MultiPolygonwith two Polygon instances'
Go

-- Exemplo 22 --
Declare @GeometryVariable Geometry
Set @GeometryVariable = Geometry::Parse('MultiLineString ((0 2, 1 1), (2 1, 1 2))')
Select @GeometryVariable As 'Two distinct LineString elements defined as a single MultiLineString'
Go

-- Exemplo 23 --
Declare @GeometryVariable Geometry
Set @GeometryVariable = Geometry::STGeomFromText('MULTIPOINT((21 2), (12 2), (30 40))', 30)
Select @GeometryVariable As 'MultiPoint that contains three Points'
Go

-- Exemplo 24 --
Declare @GeometryVariable Geometry
Set @GeometryVariable = 'GeometryCOLLECTION (POINT (4 0), LINESTRING (4 2, 5 3), POLYGON ((0 0, 3 0, 3 3, 0 3, 0 0), (1 1, 1 2, 2 2, 2 1, 1 1)))'
Select @GeometryVariable As 'GeometryCollection contains all three object types'
Go