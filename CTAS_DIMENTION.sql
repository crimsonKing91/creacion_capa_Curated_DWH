-- El orden canónico y obligatorio en una arquitectura de modelo estrella siempre es: 
-- Primero las Dimensiones, después los Hechos.


-- 1. Creamos la tabla física usando CTAS
CREATE TABLE dbo.Dim_Producto
WITH
(
    DISTRIBUTION = REPLICATE, 
    CLUSTERED COLUMNSTORE INDEX 
)
AS
-- 2. Obtenemos los productos únicos y "casteamos" (limitamos) las columnas
WITH ProductosUnicos AS (
    SELECT DISTINCT
        -- Forzamos a que dejen de ser MAX y les damos un tamaño lógico
        CAST(CODIGO_PRODUCTO AS NVARCHAR(100)) AS CODIGO_PRODUCTO,
        CAST(DESCRIPCION_COMERCIAL AS NVARCHAR(500)) AS DESCRIPCION_COMERCIAL,
        CAST(MARCA AS NVARCHAR(100)) AS MARCA,
        CAST(CATEGORIA AS NVARCHAR(100)) AS CATEGORIA,
        CAST(UNIDAD_MEDIDA AS NVARCHAR(50)) AS UNIDAD_MEDIDA
    FROM 
        dbo.stg_detallenp
    WHERE 
        CODIGO_PRODUCTO IS NOT NULL
)
-- 3. Generamos la llave subrogada
SELECT 
    ROW_NUMBER() OVER(ORDER BY CODIGO_PRODUCTO) AS Id_Producto,
    CODIGO_PRODUCTO,
    DESCRIPCION_COMERCIAL,
    MARCA,
    CATEGORIA,
    UNIDAD_MEDIDA
FROM 
    ProductosUnicos; 