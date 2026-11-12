const pool = require("../../database/pg");

exports.getVideoName = async (screenId) => {
  const query = `
    SELECT id, CONCAT(video, formato_video) AS nombre, sincronizar,
      md5(ROW(id, video, formato_video, fecha_actualizacion)::text) AS revision
    FROM public.pantalla_configuracion
    WHERE activo = true
      AND fk_id_pantalla = $1
    LIMIT 1;
  `;

  const result = await pool.query(query, [screenId]);

  return result.rowCount > 0 ? result.rows[0] : null;
};

exports.confirmSynchronization = async (screenId, configurationId, revision) => {
  // Avoid repeated updates and keep the revision of the configuration being confirmed.
  const query = `
    WITH confirmed AS (
      UPDATE public.pantalla_configuracion
      SET sincronizar = false
      WHERE id = $1 AND fk_id_pantalla = $2 AND activo = true
        AND md5(ROW(id, video, formato_video, fecha_actualizacion)::text) = $3
        AND sincronizar = true
      RETURNING id
    )
    SELECT id FROM confirmed
    UNION ALL
    SELECT id FROM public.pantalla_configuracion
    WHERE id = $1 AND fk_id_pantalla = $2 AND activo = true
      AND md5(ROW(id, video, formato_video, fecha_actualizacion)::text) = $3
      AND sincronizar = false
    LIMIT 1;
  `;
  const result = await pool.query(query, [configurationId, screenId, revision]);
  return result.rowCount > 0;
};
