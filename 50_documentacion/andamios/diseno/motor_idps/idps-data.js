/* ============================================================
   slep_idps — capa de datos (mockup)
   Datos de EJEMPLO, generados de forma determinista (0–100).
   No es un pipeline real: solo alimenta la interfaz.
   Expone window.IDPS.
   ============================================================ */
(function () {
  "use strict";

  // ----------------------------------------------------------
  // 1. Marco conceptual: 4 indicadores, 11 dimensiones
  // ----------------------------------------------------------
  const INDICADORES = [
    {
      id: "autoestima",
      n: 1,
      nombre: "Autoestima académica y motivación escolar",
      corto: "Autoestima y motivación",
      color: "#EE2D49", // mark-red
      def: "Autopercepción del estudiante sobre su capacidad de aprender y sus actitudes hacia el aprendizaje. Considera tanto la confianza en las propias aptitudes como la disposición frente al estudio.",
      dimensiones: [
        { id: "autopercepcion", nombre: "Autopercepción y autovaloración académica", corto: "Autopercepción académica",
          def: "Percepción que tienen las y los estudiantes de sus propias aptitudes y la valoración de sus habilidades para aprender las distintas asignaturas." },
        { id: "motivacion", nombre: "Motivación escolar", corto: "Motivación escolar",
          def: "Interés y disposición de las y los estudiantes hacia el aprendizaje, y su actitud para superar las dificultades que este implica." },
      ],
    },
    {
      id: "convivencia",
      n: 2,
      nombre: "Clima de convivencia escolar",
      corto: "Convivencia escolar",
      color: "#FFC92E", // mark-yellow
      def: "Percepciones y actitudes que tienen las y los estudiantes, docentes y apoderados respecto de la existencia de un ambiente de respeto, organizado y seguro en el establecimiento.",
      dimensiones: [
        { id: "respeto", nombre: "Ambiente de respeto", corto: "Ambiente de respeto",
          def: "Percepción de un trato respetuoso entre los miembros de la comunidad, valoración de la diversidad y ausencia de discriminación." },
        { id: "organizado", nombre: "Ambiente organizado", corto: "Ambiente organizado",
          def: "Existencia de normas claras, conocidas y exigidas, y de una resolución constructiva de los conflictos en el establecimiento." },
        { id: "seguro", nombre: "Ambiente seguro", corto: "Ambiente seguro",
          def: "Percepción de seguridad y de ausencia de violencia física y psicológica, junto con la existencia de mecanismos de prevención." },
      ],
    },
    {
      id: "participacion",
      n: 3,
      nombre: "Participación y formación ciudadana",
      corto: "Participación ciudadana",
      color: "#9BC93E", // mark-green
      def: "Actitudes de las y los estudiantes frente a su establecimiento y al fomento de la vida democrática, así como el grado en que la institución promueve la participación y el compromiso cívico.",
      dimensiones: [
        { id: "participacion_d", nombre: "Participación", corto: "Participación",
          def: "Oportunidades de encuentro, colaboración y comunicación que el establecimiento ofrece a estudiantes, apoderados y docentes." },
        { id: "democratica", nombre: "Vida democrática", corto: "Vida democrática",
          def: "Espacios para la expresión de opiniones, la representación estudiantil y la deliberación democrática dentro del establecimiento." },
        { id: "pertenencia", nombre: "Sentido de pertenencia", corto: "Sentido de pertenencia",
          def: "Grado de identificación y orgullo de las y los estudiantes por pertenecer a su establecimiento." },
      ],
    },
    {
      id: "habitos",
      n: 4,
      nombre: "Hábitos de vida saludable",
      corto: "Vida saludable",
      color: "#2A8FD9", // mark-blue
      def: "Actitudes y conductas autodeclaradas de las y los estudiantes frente a una vida saludable, y la promoción que el establecimiento hace de estas.",
      dimensiones: [
        { id: "alimenticios", nombre: "Hábitos alimenticios", corto: "Hábitos alimenticios",
          def: "Actitud de las y los estudiantes frente a la alimentación saludable y la promoción que el establecimiento realiza de ella." },
        { id: "activa", nombre: "Hábitos de vida activa", corto: "Vida activa",
          def: "Actitud frente a la actividad física y deportiva, y la promoción que el establecimiento hace de la vida activa." },
        { id: "autocuidado", nombre: "Hábitos de autocuidado", corto: "Autocuidado",
          def: "Actitud frente al consumo de sustancias y la adopción de conductas de autocuidado, junto con su promoción institucional." },
      ],
    },
  ];

  // Lista plana de las 11 dimensiones, en orden, con su indicador padre
  const DIMENSIONES = [];
  INDICADORES.forEach((ind) => {
    ind.dimensiones.forEach((d) => {
      DIMENSIONES.push({ ...d, indId: ind.id, indNombre: ind.nombre, indN: ind.n, color: ind.color });
    });
  });

  // ----------------------------------------------------------
  // 2. GSE — siempre presente. 1 Bajo … 5 Alto
  // ----------------------------------------------------------
  const GSE = [
    { cod: 1, label: "GSE 1 · Bajo", corto: "Bajo" },
    { cod: 2, label: "GSE 2 · Medio bajo", corto: "Medio bajo" },
    { cod: 3, label: "GSE 3 · Medio", corto: "Medio" },
    { cod: 4, label: "GSE 4 · Medio alto", corto: "Medio alto" },
    { cod: 5, label: "GSE 5 · Alto", corto: "Alto" },
  ];

  // ----------------------------------------------------------
  // 3. Grados y cobertura temporal (asimétrica, intencional)
  // ----------------------------------------------------------
  const GRADOS = [
    { id: "2m", label: "2° medio",  anios: [2022, 2023, 2024, 2025] }, // serie larga
    { id: "4b", label: "4° básico", anios: [2022, 2023, 2025] },        // falta 2024
    { id: "6b", label: "6° básico", anios: [2024] },                    // corte único
    { id: "8b", label: "8° básico", anios: [2025] },                    // corte único
  ];
  const PRELIMINAR = [2025];
  const TODOS_ANIOS = [2022, 2023, 2024, 2025];

  // ----------------------------------------------------------
  // 4. Catálogo territorial — TODO Chile disponible
  //    Niveles: país · región · slep · comuna · establecimiento
  // ----------------------------------------------------------
  const REGIONES = [
    { id: "r15", nombre: "Arica y Parinacota" },
    { id: "r01", nombre: "Tarapacá" },
    { id: "r02", nombre: "Antofagasta" },
    { id: "r03", nombre: "Atacama" },
    { id: "r04", nombre: "Coquimbo" },
    { id: "r05", nombre: "Valparaíso" },
    { id: "r13", nombre: "Metropolitana de Santiago" },
    { id: "r06", nombre: "O'Higgins" },
    { id: "r07", nombre: "Maule" },
    { id: "r16", nombre: "Ñuble" },
    { id: "r08", nombre: "Biobío" },
    { id: "r09", nombre: "La Araucanía" },
    { id: "r14", nombre: "Los Ríos" },
    { id: "r10", nombre: "Los Lagos" },
    { id: "r11", nombre: "Aysén" },
    { id: "r12", nombre: "Magallanes" },
  ];

  // SLEPs (selección plausible; Costa Central es el foco)
  const SLEPS = [
    { id: "slep_costacentral", nombre: "Costa Central", region: "r05", comunas: ["concon", "puchuncavi", "quintero", "vinadelmar"] },
    { id: "slep_valparaiso",   nombre: "Valparaíso",   region: "r05", comunas: ["valparaiso", "juanfernandez"] },
    { id: "slep_andalien",     nombre: "Andalién Sur", region: "r08", comunas: ["concepcion", "chiguayante", "hualqui"] },
    { id: "slep_gabriela",     nombre: "Gabriela Mistral", region: "r13", comunas: ["santiago", "macul"] },
    { id: "slep_barrancas",    nombre: "Barrancas",    region: "r13", comunas: ["pudahuel", "lopranado", "cerronavia"] },
    { id: "slep_puertocord",   nombre: "Puerto Cordillera", region: "r04", comunas: ["coquimbo", "andacollo"] },
  ];

  // Comunas (las 4 de Costa Central + algunas nacionales para mostrar alcance)
  const COMUNAS = [
    { id: "concon",      nombre: "Concón",        region: "r05", slep: "slep_costacentral" },
    { id: "puchuncavi",  nombre: "Puchuncaví",    region: "r05", slep: "slep_costacentral" },
    { id: "quintero",    nombre: "Quintero",      region: "r05", slep: "slep_costacentral" },
    { id: "vinadelmar",  nombre: "Viña del Mar",  region: "r05", slep: "slep_costacentral" },
    { id: "valparaiso",  nombre: "Valparaíso",    region: "r05", slep: "slep_valparaiso" },
    { id: "juanfernandez", nombre: "Juan Fernández", region: "r05", slep: "slep_valparaiso" },
    { id: "santiago",    nombre: "Santiago",      region: "r13", slep: "slep_gabriela" },
    { id: "macul",       nombre: "Macul",         region: "r13", slep: "slep_gabriela" },
    { id: "concepcion",  nombre: "Concepción",    region: "r08", slep: "slep_andalien" },
    { id: "chiguayante", nombre: "Chiguayante",   region: "r08", slep: "slep_andalien" },
    { id: "hualqui",     nombre: "Hualqui",       region: "r08", slep: "slep_andalien" },
    { id: "coquimbo",    nombre: "Coquimbo",      region: "r04", slep: "slep_puertocord" },
    { id: "andacollo",   nombre: "Andacollo",     region: "r04", slep: "slep_puertocord" },
    { id: "pudahuel",    nombre: "Pudahuel",      region: "r13", slep: "slep_barrancas" },
    { id: "cerronavia",  nombre: "Cerro Navia",   region: "r13", slep: "slep_barrancas" },
  ];

  // Establecimientos (algunos dentro de Costa Central)
  const ESTABLECIMIENTOS = [
    { id: "e1", rbd: "1631", nombre: "Liceo Bicentenario de Viña del Mar", comuna: "vinadelmar", region: "r05", slep: "slep_costacentral" },
    { id: "e2", rbd: "1702", nombre: "Escuela República del Ecuador", comuna: "vinadelmar", region: "r05", slep: "slep_costacentral" },
    { id: "e3", rbd: "1845", nombre: "Liceo Politécnico de Concón", comuna: "concon", region: "r05", slep: "slep_costacentral" },
    { id: "e4", rbd: "1912", nombre: "Escuela Básica de Quintero", comuna: "quintero", region: "r05", slep: "slep_costacentral" },
    { id: "e5", rbd: "2033", nombre: "Escuela Rural de Puchuncaví", comuna: "puchuncavi", region: "r05", slep: "slep_costacentral" },
    { id: "e6", rbd: "0855", nombre: "Liceo de Aplicación", comuna: "santiago", region: "r13", slep: "slep_gabriela" },
  ];

  // País
  const PAIS = { id: "chile", nombre: "Chile (total nacional)" };

  // Paleta de territorios — usa la PALETA DE MARCA (no choca con los colores
  // de indicador, que son rojo/amarillo/verde/azul).
  const TERRITORIO_PALETTE = ["#4A2746", "#0062A0", "#E88663", "#75924E"]; // plum, ocean, coral, olive
  const MAX_TERRITORIOS = 4;

  // ----------------------------------------------------------
  // 5. Generador determinista de valores 0–100
  // ----------------------------------------------------------
  function hash(str) {
    let h = 2166136261;
    for (let i = 0; i < str.length; i++) {
      h ^= str.charCodeAt(i);
      h = Math.imul(h, 16777619);
    }
    return (h >>> 0) / 4294967295; // 0..1
  }

  // Línea base por territorio (estable). Mayor GSE ⇒ leve alza.
  function baseTerritorio(territorioKey) {
    return 58 + hash("base|" + territorioKey) * 22; // 58..80
  }

  // Valor de una dimensión para (territorio, gse, grado, dim, año)
  function valorDimension(territorioKey, gse, gradoId, dimId, anio) {
    const base = baseTerritorio(territorioKey);
    const gseEfecto = (gse - 3) * 2.4; // GSE alto un poco más alto
    const dimEfecto = (hash(dimId + "|" + territorioKey) - 0.5) * 26; // perfil por dimensión
    const anioEfecto = (anio - 2022) * (hash("trend|" + territorioKey + "|" + dimId) - 0.42) * 4.5; // deriva temporal suave
    const ruido = (hash(territorioKey + "|" + gse + "|" + gradoId + "|" + dimId + "|" + anio) - 0.5) * 7;
    let v = base + gseEfecto + dimEfecto + anioEfecto + ruido;
    return Math.max(8, Math.min(98, Math.round(v * 10) / 10));
  }

  // Supresión por resguardo estadístico: algunos establecimientos pequeños
  // y GSE poco poblados devuelven "sin dato" (null), NUNCA cero.
  function estaSuprimido(territorio, gse, gradoId, anio) {
    if (territorio.kind === "estab") {
      // establecimientos pequeños: ciertos GSE no aplican / se suprimen
      const r = hash("sup|" + territorio.key + "|" + gse + "|" + gradoId);
      return r < 0.45; // ~ casi la mitad de las celdas GSE de un estab no tienen dato
    }
    if (territorio.kind === "comuna") {
      const r = hash("sup|" + territorio.key + "|" + gse + "|" + gradoId + "|" + anio);
      return r < 0.06;
    }
    return false; // slep/región/país siempre tienen dato
  }

  // ----------------------------------------------------------
  // 6. API de consulta
  // ----------------------------------------------------------
  // territorio: objeto { kind, id, key, nombre, ... }
  // Devuelve { [dimId]: valor|null } para un grado/gse/año
  function dimsDe(territorio, gse, gradoId, anio) {
    const out = {};
    const suprimido = estaSuprimido(territorio, gse, gradoId, anio);
    DIMENSIONES.forEach((d) => {
      out[d.id] = suprimido ? null : valorDimension(territorio.key, gse, gradoId, d.id, anio);
    });
    return out;
  }

  // Valor de indicador = promedio de sus dimensiones (null si todas null)
  function indicadoresDe(territorio, gse, gradoId, anio) {
    const dims = dimsDe(territorio, gse, gradoId, anio);
    const out = {};
    INDICADORES.forEach((ind) => {
      const vals = ind.dimensiones.map((d) => dims[d.id]).filter((v) => v != null);
      out[ind.id] = vals.length ? Math.round((vals.reduce((a, b) => a + b, 0) / vals.length) * 10) / 10 : null;
    });
    return out;
  }

  // Serie histórica de una métrica (indicador o dimensión) para un territorio/gse/grado
  // metricKind: "indicador" | "dimension"
  // Cada punto trae la significancia estadística del cambio respecto de la
  // medición anterior disponible (sigVsPrev): true = diferencia significativa,
  // false = no significativa, null = sin comparación posible.
  function serie(territorio, gse, gradoId, metricId, metricKind) {
    const grado = GRADOS.find((g) => g.id === gradoId);
    let prev = null; // { anio, valor }
    return grado.anios.map((anio) => {
      const vals = metricKind === "indicador"
        ? indicadoresDe(territorio, gse, gradoId, anio)
        : dimsDe(territorio, gse, gradoId, anio);
      const valor = vals[metricId];
      let sigVsPrev = null, deltaVsPrev = null, prevAnio = null;
      if (valor != null && prev != null) {
        deltaVsPrev = Math.round((valor - prev.valor) * 10) / 10;
        prevAnio = prev.anio;
        const thr = 2 + hash("sig|" + territorio.key + "|" + metricId + "|" + gradoId + "|" + anio) * 3.2; // umbral 2.0–5.2
        sigVsPrev = Math.abs(deltaVsPrev) >= thr;
      }
      const point = { anio, valor, preliminar: PRELIMINAR.includes(anio), sigVsPrev, deltaVsPrev, prevAnio };
      if (valor != null) prev = { anio, valor };
      return point;
    });
  }

  // Distribución Bajo/Medio/Alto por dimensión (suma 100; null si suprimido)
  function distribucionDim(territorio, gse, gradoId, dimId, anio) {
    if (estaSuprimido(territorio, gse, gradoId, anio)) return null;
    const v = valorDimension(territorio.key, gse, gradoId, dimId, anio); // 0..100, "favorabilidad"
    // Mapear puntaje a una mezcla plausible: a mayor puntaje, más "Alto".
    let alto = Math.max(6, Math.min(86, v - 8 + (hash("alto|" + dimId + territorio.key) - 0.5) * 10));
    let bajo = Math.max(3, Math.min(60, (100 - v) * 0.55 + (hash("bajo|" + dimId + territorio.key) - 0.5) * 8));
    let medio = 100 - alto - bajo;
    if (medio < 6) { medio = 6; const exc = (alto + bajo + medio) - 100; alto -= exc * 0.6; bajo -= exc * 0.4; }
    const round1 = (x) => Math.round(x * 10) / 10;
    return { bajo: round1(bajo), medio: round1(100 - round1(alto) - round1(bajo)), alto: round1(alto) };
  }

  // Año más reciente disponible para un grado
  function anioReciente(gradoId) {
    const g = GRADOS.find((x) => x.id === gradoId);
    return g.anios[g.anios.length - 1];
  }

  // ----------------------------------------------------------
  // Exportar
  // ----------------------------------------------------------
  window.IDPS = {
    INDICADORES, DIMENSIONES, GSE, GRADOS, PRELIMINAR, TODOS_ANIOS,
    REGIONES, SLEPS, COMUNAS, ESTABLECIMIENTOS, PAIS,
    TERRITORIO_PALETTE, MAX_TERRITORIOS,
    dimsDe, indicadoresDe, serie, distribucionDim, anioReciente,
    intro: "Los Indicadores de Desarrollo Personal y Social (IDPS) son un conjunto de índices de la Agencia de Calidad de la Educación que miden el desarrollo personal y social de las y los estudiantes, complementando los resultados académicos del Simce. Se construyen a partir de cuestionarios tipo Likert aplicados a estudiantes, docentes y apoderados. Su puntaje va de 0 a 100, donde 100 representa las percepciones más positivas, y son un insumo de la Categoría de Desempeño de cada establecimiento.",
  };
})();
