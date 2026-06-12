# Corpus conceptual de los IDPS (indicadores de cuestionario)

> Documento conceptual de referencia para el proyecto `slep_idps`. Alimenta la seccion metodologica del motor y las definiciones accesibles por subdimension en la interfaz (P9/P10). Generado desde `idps_corpus_conceptual.json` (fuente unica); no editar a mano: editar el JSON y regenerar.

**Version:** 1.1  
**Generado:** 2026-06-12

## Alcance

4 indicadores medidos via Cuestionarios de Calidad y Contexto (Autoestima academica y motivacion escolar, Clima de convivencia escolar, Participacion y formacion ciudadana, Habitos de vida saludable). Excluye los 4 indicadores administrativos (Asistencia, Retencion, Equidad de genero en aprendizajes, Titulacion tecnico-profesional).

## Fuentes

- Marco de Evaluacion de los IDPS, Agencia de Calidad de la Educacion, Division de Estudio y Gestion del Conocimiento, octubre 2024 (fuente canonica de la estructura indicador/dimension/subdimension/actor y de las definiciones operacionales de subdimension).
- Que son los IDPS y que hacen los establecimientos para promoverlos, Mineduc / Unidad de Curriculum y Evaluacion, octubre 2019, basado en el Decreto Supremo 381/2013 (fuente de la caracterizacion cualitativa de nivel alto por indicador y de las definiciones de dimension).
- Descripcion de subdimensiones y niveles de desarrollo IDPS, Agencia de Calidad de la Educacion, marzo 2025 (datos de los Cuestionarios 2024, 4 basico / 6 basico / II medio). Fuente de la descripcion cualitativa por nivel y por ciclo.

**Base normativa:** Decreto Supremo de Educacion 381/2013. Denominados en la Ley 20.529 como Otros Indicadores de Calidad Educativa (OIC).

## Para que sirven los IDPS

Los Indicadores de Desarrollo Personal y Social (IDPS) son un conjunto de indices estadisticos que entregan informacion sobre la formacion integral de los estudiantes, de manera complementaria a los resultados Simce y a los Estandares de Aprendizaje, ampliando el concepto de calidad educativa mas alla del dominio del conocimiento academico. La Agencia de Calidad de la Educacion los mide, informa y orienta. Sus funciones principales:

- Entregar informacion a los establecimientos sobre distintas areas de desarrollo de sus estudiantes.
- Servir de insumo para la **Categoria de Desempeno** y la Ordenacion de los establecimientos (junto con Simce, Estandares de Aprendizaje y caracteristicas de los alumnos).
- Identificar establecimientos que requieren orientacion y apoyo.
- Disenar y evaluar politicas educativas a nivel nacional.

De los ocho IDPS, **cuatro se miden mediante los Cuestionarios de Calidad y Contexto de la Educacion** (los de este corpus); los otros cuatro (Asistencia, Retencion, Equidad de genero en aprendizajes, Titulacion tecnico-profesional) se calculan a partir de informacion administrativa y quedan fuera de este alcance.

## Como estan compuestos

La estructura es jerarquica: **indicador -> dimension -> subdimension -> actor**. El Decreto 381/2013 define cuatro indicadores y once dimensiones; la Agencia, mediante analisis psicometricos, identifico y valido las **subdimensiones** como los factores que componen cada dimension. Cada subdimension se mide a traves de uno o mas actores: estudiantes (EST), docentes (DOC) y/o apoderados (PAD).

| Indicador | Dimensiones | Subdimensiones |
|---|---|---|
| Autoestima academica y motivacion escolar | 2 | 4 |
| Clima de convivencia escolar | 3 | 13 |
| Participacion y formacion ciudadana | 3 | 7 |
| Habitos de vida saludable | 3 | 6 |
| **Total (4 indicadores)** | **11** | **30** |

## Niveles de desarrollo

Cada subdimension reporta el porcentaje de estudiantes distribuidos en niveles de desarrollo: tres niveles (Alto / Medio / Bajo) o dos niveles (Alto / Bajo), segun el aspecto evaluado. La descripcion cualitativa por nivel proviene del documento 'Descripcion de subdimensiones y niveles de desarrollo IDPS' (Agencia, 2024) y se guarda en 'descripcion_niveles_subdimension', separada por ciclo: 'basica' (4 y 6 basico) y 'media' (II medio), porque varias subdimensiones difieren entre ciclos.

> **Regla del dominio:** Los niveles de desarrollo se reportan SOLO para subdimensiones evaluadas en estudiantes (EST), ya que se construyen a partir de sus respuestas. Las subdimensiones de actor DOC y/o PAD no tienen niveles: descripcion_niveles_subdimension=null con motivo declarado. La UI debe tratar esta ausencia como intencional, no como dato faltante.

## Nota sobre el Marco 2025 v3

El archivo 'Marco Evaluacion IDPS 2025 v3.pdf' es, en contenido, identico a la edicion de octubre 2024 (mismas 11 dimensiones, 30 subdimensiones, definiciones y actores). No introduce cambios de estructura. La estructura canonica se mantiene.

## Variantes de nombre

- **Participacion (subdimension de la dimension Participacion):** En el documento de niveles aparece como 'Participacion de la o el estudiante'. Misma subdimension.
- **Actitud frente a la actividad fisica (subdimension):** En la tabla 14 del Marco figura como 'Actitud frente a la vida activa'; en el cuerpo (tabla 16) y en el documento de niveles, como 'Actitud frente a la actividad fisica'. Misma subdimension.

## Caracterizacion de nivel alto: alcance

Las listas de "que caracteriza a un establecimiento que puntua alto" (folleto 2019) describen practicas a **nivel de indicador**, no de subdimension ni de dimension. Responden a la pregunta de implicancia: un indicador alto refleja que el establecimiento implementa sistematicamente esas practicas; un indicador bajo, su ausencia o debilidad. **No deben presentarse como descripcion de un nivel de subdimension.**

---

# Detalle por indicador

## Autoestima academica y motivacion escolar

**Definicion.** Considera, por una parte, la autopercepcion y la autovaloracion de los estudiantes en relacion a su capacidad de aprender y, por otra parte, las percepciones y actitudes que tienen hacia el aprendizaje y el logro academico.

**Como se evalua.** Cuestionarios de Calidad y Contexto de la Educacion para estudiantes. Valores cercanos a 100 para percepciones positivas y cercanos a 0 para negativas. El puntaje del indicador se calcula por ciclo, promediando los puntajes obtenidos en cada grado.

**Por que importa.** La autoestima academica y la motivacion escolar influyen en el proceso de aprendizaje, la salud y el bienestar. Impactan positivamente el rendimiento academico, fortalecen la formacion socioemocional (confianza en si mismos, seguridad para asumir desafios y generar vinculos sin temor al fracaso) y disminuyen la probabilidad de conductas de riesgo.

### Dimensiones y subdimensiones

#### Autopercepcion y autovaloracion academica

Incluye tanto las percepciones de los estudiantes frente a sus aptitudes, habilidades y posibilidades de superarse, como la valoracion que hacen sobre sus atributos y habilidades en el ambito academico.

**Autovaloracion academica** (Estudiantes)  
Evalua la percepcion que tienen los estudiantes acerca de su propia capacidad de entender, explicar, analizar y evaluar contenidos academicos para obtener buenos resultados educativos.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes se perciben capaces de obtener buenos resultados educativos, y de entender y decodificar informacion o contenidos. Ademas, se perciben capaces de presentar, transmitir, analizar, evaluar y crear informacion o contenidos academicos.
- **Medio:** Los y las estudiantes se perciben capaces de obtener buenos resultados educativos y capaces de entender y decodificar informacion o contenidos academicos.
- **Bajo:** Los y las estudiantes se perciben poco capaces de obtener buenos resultados educativos, asi como de entender y decodificar informacion o contenidos academicos.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes se perciben capaces de obtener buenos resultados educativos, y de entender y decodificar informacion o contenidos. Ademas, se perciben capaces de presentar, transmitir, analizar, evaluar y crear informacion o contenidos academicos.
- **Medio:** Los y las estudiantes se perciben capaces de obtener buenos resultados educativos y capaces de entender y decodificar informacion o contenidos academicos.
- **Bajo:** Los y las estudiantes se perciben poco capaces de obtener buenos resultados educativos, asi como de entender y decodificar informacion o contenidos academicos.

**Promocion de la autovaloracion academica** (Estudiantes)  
Evalua la frecuencia percibida por los estudiantes de aquellas acciones realizadas por sus docentes que promueven la autovaloracion academica, tales como reconocer sus capacidades, logros, avances y mejoras en el ambito escolar, para transmitirles confianza y seguridad en sus propias capacidades.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben que sus profesores(as) realizan acciones que promueven una autovaloracion academica positiva, como decirles que son capaces de aprender, reconocer sus avances y felicitarlos(as) por su esfuerzo. Ademas, los animan a ser mejores estudiantes y reconocen sus logros frente al curso.
- **Medio:** Los y las estudiantes perciben que sus profesores(as) realizan acciones que promueven una autovaloracion academica positiva, tales como decirles que son capaces de aprender, reconocer sus avances y felicitarlos(as) por su esfuerzo.
- **Bajo:** Los y las estudiantes perciben que sus profesores(as) pocas veces o nunca realizan acciones que promueven una autovaloracion academica positiva, tales como decirles que son capaces de aprender, reconocer sus avances y felicitarlos(as) por su esfuerzo.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que sus profesores(as) realizan acciones que promueven una autovaloracion academica positiva, como decirles que son capaces de aprender, reconocer sus avances y felicitarlos(as) por su esfuerzo. Ademas, los animan a ser mejores estudiantes y reconocen sus logros frente al curso.
- **Medio:** Los y las estudiantes perciben que sus profesores(as) realizan acciones que promueven una autovaloracion academica positiva, tales como decirles que son capaces de aprender, reconocer sus avances y felicitarlos(as) por su esfuerzo.
- **Bajo:** Los y las estudiantes perciben que sus profesores(as) pocas veces o nunca realizan acciones que promueven una autovaloracion academica positiva, tales como decirles que son capaces de aprender, reconocer sus avances y felicitarlos(as) por su esfuerzo.

#### Motivacion escolar

Incluye las percepciones de los estudiantes respecto de su interes y disposicion al aprendizaje, sus expectativas academicas y motivacion al logro, y sus actitudes frente a las dificultades y la frustracion en el estudio.

**Interes y disposicion al aprendizaje** (Estudiantes)  
Evalua la percepcion que tienen los estudiantes acerca de su propio interes, gusto y esfuerzo dedicado a las actividades escolares y al aprendizaje academico, considerando la perseverancia, la tolerancia a la frustracion y la actitud ante los desafios.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes se describen a si mismos(as) con interes y disposicion a aprender, senalando que les gusta hacer tareas y trabajos, les parece importante aprender cosas nuevas y les gusta participar y hacer trabajos en clases. Ademas, les gusta aprender mas de lo que les ensenan en clases, hacer tareas y trabajos dificiles, y estudiar y esforzarse por aprender, aunque los contenidos no les gusten o les parezcan aburridos.
- **Medio:** Los y las estudiantes se describen a si mismos(as) con interes y disposicion a aprender, senalando que les gusta hacer tareas y trabajos, les parece importante aprender cosas nuevas y les gusta participar y hacer trabajos en clases.
- **Bajo:** Los y las estudiantes se describen a si mismos(as) con poco interes y disposicion a aprender, senalando que no les gusta hacer tareas y trabajos, no les parece importante aprender cosas nuevas y no les gusta participar ni hacer trabajos en clases.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes se describen a si mismos(as) con interes y disposicion a aprender, senalando que les gusta hacer tareas y trabajos, les parece importante aprender cosas nuevas y les gusta participar y hacer trabajos en clases. Ademas, les gusta aprender mas de lo que les ensenan en clases, hacer tareas y trabajos dificiles, y estudiar y esforzarse por aprender, aunque los contenidos no les gusten o les parezcan aburridos.
- **Medio:** Los y las estudiantes se describen a si mismos(as) con interes y disposicion a aprender, senalando que les gusta hacer tareas y trabajos, les parece importante aprender cosas nuevas y les gusta participar y hacer trabajos en clases.
- **Bajo:** Los y las estudiantes se describen a si mismos(as) con poco interes y disposicion a aprender, senalando que no les gusta hacer tareas y trabajos, no les parece importante aprender cosas nuevas y no les gusta participar ni hacer trabajos en clases.

**Promocion de la motivacion al aprendizaje** (Estudiantes)  
Evalua la percepcion de los estudiantes acerca de las acciones realizadas por sus docentes que promueven la motivacion por el aprendizaje, las actividades escolares, la capacidad de mejorar y la autoconfianza.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben que sus profesores(as) los motivan a aprender, senalando que los animan a estudiar, a esforzarse y a preguntar en clases, y que los hacen sentirse capaces de resolver hasta las tareas mas dificiles. Ademas, perciben que sus profesores(as) hacen clases interesantes, les dicen como corregir sus errores y les ayudan a dar lo mejor de si.
- **Bajo:** Los y las estudiantes perciben que sus profesores(as) no los motivan a aprender, senalando que pocas veces los animan a estudiar, a esforzarse y a preguntar en clases, y que pocas veces los hacen sentirse capaces de resolver hasta las tareas mas dificiles. Ademas, perciben que no hacen clases interesantes.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que sus profesores(as) los motivan a aprender, senalando que los animan a estudiar, a esforzarse y a preguntar en clases, y que los hacen sentirse capaces de resolver hasta las tareas mas dificiles. Ademas, perciben que sus profesores(as) hacen clases interesantes, les dicen como corregir sus errores y les ayudan a dar lo mejor de si.
- **Bajo:** Los y las estudiantes perciben que sus profesores(as) no los motivan a aprender, senalando que pocas veces los animan a estudiar, a esforzarse y a preguntar en clases, y que pocas veces los hacen sentirse capaces de resolver hasta las tareas mas dificiles. Ademas, perciben que no hacen clases interesantes.

### Que caracteriza a un establecimiento que puntua alto en este indicador

*(Nivel indicador. Su ausencia caracteriza el nivel bajo.)*

- Promueven un trato respetuoso y afectivo.
- Generan ambientes acogedores y seguros.
- Desarrollan una imagen positiva de cada curso.
- Ayudan a que los estudiantes se movilicen para mejorar los aspectos en que presentan dificultades.
- Comunican confianza en las capacidades de los estudiantes y transmiten altas expectativas.
- Muestran que los errores son parte normal y fuente de crecimiento en el aprendizaje.
- Entregan oportunidades para que cada estudiante se sienta capaz en alguna area o actividad.
- Diversifican estrategias de aprendizaje para generar mayor interes.
- Detectan tempranamente dificultades academicas o socioafectivas e implementan acciones de apoyo.
- Desarrollan un vinculo afectivo entre los actores de la comunidad educativa y los estudiantes.
- Refuerzan positivamente a sus estudiantes.
- Generan instancias permanentes de reflexion.
- Fomentan la formacion continua de los docentes en autoestima y motivacion escolar.

---

## Clima de convivencia escolar

**Definicion.** Considera las percepciones y las actitudes que tienen estudiantes, docentes, madres, padres y apoderados(as) con respecto a la presencia de un ambiente de respeto, organizado y seguro en el establecimiento.

**Como se evalua.** Cuestionarios de Calidad y Contexto de la Educacion para estudiantes, docentes y padres y apoderados. Valores cercanos a 100 para percepciones positivas y cercanos a 0 para negativas, de los tres actores. El puntaje del indicador se calcula por ciclo, promediando los puntajes obtenidos en cada grado.

**Por que importa.** Impacta el desarrollo socioemocional, la conducta y la disposicion hacia el aprendizaje, y afecta el bienestar de todos los actores. Un buen clima permite que los estudiantes se sientan seguros fisica y emocionalmente, provee condiciones propicias para el aprendizaje y favorece el bienestar de los docentes.

### Dimensiones y subdimensiones

#### Ambiente de respeto

Considera las percepciones y actitudes de estudiantes, docentes, madres, padres y apoderados(as) en relacion al trato respetuoso entre los miembros de la comunidad educativa, la valoracion de la diversidad y la ausencia de discriminacion. Ademas, considera las percepciones respecto al cuidado del establecimiento y el respeto al entorno de parte de los estudiantes.

**Cohesion social entre estudiantes** (Estudiantes)  
Evalua la percepcion que tienen los estudiantes acerca de las relaciones sociales entre companeros(as) de curso, considerando el buen trato, el respeto, la confianza, el apoyo y la inclusion social.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes describen a su curso como unido, senalando que sus companeras y companeros son amistosos(as), se tratan con respeto y se llevan bien. Ademas, sienten confianza con sus companeros y companeras, y se sienten aceptados(as), apoyados(as) e incluidos(as) en el curso.
- **Medio:** Los y las estudiantes describen a su curso como unido, senalando que sus companeras y companeros son amistosos(as), se tratan con respeto y se llevan bien. Ademas, se sienten aceptados(as) en el curso.
- **Bajo:** Los y las estudiantes describen a su curso como poco unido, senalando que sus companeras y companeros son poco amistosos(as) y no se tratan bien. Ademas, senalan que se sienten poco aceptados(as) y no confian en sus companeros y companeras.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes describen a su curso como unido, senalando que sus companeras y companeros son amistosos(as), se tratan con respeto y se llevan bien. Ademas, sienten confianza con sus companeros y companeras, y se sienten aceptados(as), apoyados(as) e incluidos(as) en el curso.
- **Medio:** Los y las estudiantes describen a su curso como unido, senalando que sus companeras y companeros son amistosos(as), se tratan con respeto y se llevan bien. Ademas, se sienten aceptados(as) en el curso.
- **Bajo:** Los y las estudiantes describen a su curso como poco unido, senalando que sus companeros y companeras son poco amistosos(as) y no se tratan bien. Ademas, senalan que se sienten poco aceptados(as) y no confian en sus companeros y companeras.

**Apoyo y buen trato de los docentes** (Estudiantes)  
Evalua la percepcion que tienen los estudiantes acerca del trato respetuoso recibido por sus docentes, considerando el buen trato, la integracion, el apoyo y la no discriminacion.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben que sus profesores y profesoras les brindan apoyo, senalando que los tratan con respeto, se sienten aceptados(as) por ellos(as) y se preocupan de que ningun estudiante sea discriminado(a). Ademas, se dan cuenta cuando los y las estudiantes tienen un problema y les ayudan a ver lo bueno en cada uno de ellos(as).
- **Medio:** Los y las estudiantes perciben que sus profesores y profesoras los apoyan, senalando que tratan a los estudiantes con respeto, se sienten aceptados(as) por ellos(as) y se preocupan de que ningun estudiante sea discriminado(a).
- **Bajo:** Los y las estudiantes no perciben el apoyo de sus profesores y profesoras, describiendolos como poco respetuosos. Ademas, se sienten poco aceptados(as) por ellos(as) y les parece que no se preocupan de que ningun estudiante sea discriminado(a).

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que sus profesores y profesoras les brindan apoyo, senalando que los tratan con respeto, se sienten aceptados(as) por ellos(as) y se preocupan de que ningun estudiante sea discriminado(a). Ademas, se dan cuenta cuando los y las estudiantes tienen un problema y les ayudan a ver lo bueno en cada uno de ellos(as).
- **Medio:** Los y las estudiantes perciben que sus profesores y profesoras los apoyan, senalando que tratan a los estudiantes con respeto, se sienten aceptados(as) por ellos(as) y se preocupan de que ningun estudiante sea discriminado(a).
- **Bajo:** Los y las estudiantes no perciben el apoyo de sus profesores y profesoras, describiendolos como poco respetuosos. Ademas, se sienten poco aceptados(as) por ellos(as) y les parece que no se preocupan de que ningun estudiante sea discriminado(a).

**Trato entre docentes** (Docentes)  
Evalua la percepcion de los docentes acerca de las relaciones con sus pares, considerando el trabajo en equipo, la confianza y la inclusion.

*Niveles de desarrollo: no aplica. Subdimension no evaluada en estudiantes (actores: DOC); los niveles de desarrollo solo se reportan para EST.*

**Trato entre estudiantes** (Docentes)  
Evalua la percepcion de los docentes acerca de las relaciones entre estudiantes, considerando el buen trato, la colaboracion y la inclusion.

*Niveles de desarrollo: no aplica. Subdimension no evaluada en estudiantes (actores: DOC); los niveles de desarrollo solo se reportan para EST.*

**Trato entre apoderados(as)** (Madres, padres y/o apoderados(as))  
Evalua la percepcion de madres, padres y/o apoderados(as) acerca de las relaciones entre sus pares, considerando el buen trato, la colaboracion y la confianza.

*Niveles de desarrollo: no aplica. Subdimension no evaluada en estudiantes (actores: PAD); los niveles de desarrollo solo se reportan para EST.*

**Trato en el colegio** (Madres, padres y/o apoderados(as))  
Evalua la percepcion de madres, padres y/o apoderados(as) acerca de las relaciones sociales al interior de la comunidad educativa, considerando buen trato, colaboracion y confianza.

*Niveles de desarrollo: no aplica. Subdimension no evaluada en estudiantes (actores: PAD); los niveles de desarrollo solo se reportan para EST.*

**Gestion de la inclusion** (Docentes)  
Evalua la percepcion de los docentes acerca de la importancia de promover la inclusion y el valor a la diversidad en la comunidad educativa, asi como las condiciones pedagogicas para abordarla.

*Niveles de desarrollo: no aplica. Subdimension no evaluada en estudiantes (actores: DOC); los niveles de desarrollo solo se reportan para EST.*

#### Ambiente organizado

Considera las percepciones de estudiantes, docentes, madres, padres y apoderados(as) sobre la existencia de normas claras, conocidas, exigidas y respetadas por todos, y el predominio de mecanismos constructivos de resolucion de conflictos. Ademas, considera las actitudes de los estudiantes frente a las normas de convivencia y su transgresion.

**Ambiente organizado para el aprendizaje** (Estudiantes, Docentes)  
Evalua la percepcion que tienen los estudiantes y sus docentes acerca de las condiciones al interior del aula que son propicias para el aprendizaje, tales como el conocimiento y el respeto de normas de convivencia y la organizacion al interior del curso.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben, al interior del aula, un buen ambiente para el aprendizaje. Indican que, en este espacio, las normas de convivencia se construyen colaborativamente, son claras, se respetan y son justas. Ademas, senalan que se respetan los turnos, la puntualidad y el silencio durante las clases en el curso.
- **Medio:** Los y las estudiantes perciben, al interior del aula, un buen ambiente para el aprendizaje. Indican que, en este espacio, las normas de convivencia se construyen colaborativamente, son claras, se respetan y son justas. Por otra parte, senalan que se respetan poco los turnos, la puntualidad y el silencio durante las clases en el curso.
- **Bajo:** Los y las estudiantes perciben, al interior del aula, un mal ambiente para el aprendizaje. Indican que, en este espacio, las normas de convivencia no se construyen colaborativamente, no son claras, no se respetan y no son justas. Por otra parte, senalan que se respetan poco los turnos, la puntualidad y el silencio durante las clases en el curso.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben, al interior del aula, un buen ambiente para el aprendizaje. Indican que, en este espacio, las normas de convivencia se construyen colaborativamente, son claras, se respetan y son justas. Ademas, senalan que se respetan los turnos, la puntualidad y el silencio durante las clases en el curso.
- **Medio:** Los y las estudiantes perciben, al interior del aula, un buen ambiente para el aprendizaje. Indican que, en este espacio, las normas de convivencia se construyen colaborativamente, son claras, se respetan y son justas. Por otra parte, senalan que se respetan poco los turnos, la puntualidad y el silencio durante las clases en el curso.
- **Bajo:** Los y las estudiantes perciben, al interior del aula, un mal ambiente para el aprendizaje. Indican que, en este espacio, las normas de convivencia no se construyen colaborativamente, no son claras, no se respetan y no son justas. Por otra parte, senalan que se respetan poco los turnos, la puntualidad y el silencio durante las clases en el curso.

**Promocion de mecanismos constructivos de resolucion de conflictos** (Estudiantes, Docentes, Madres, padres y/o apoderados(as))  
Evalua la percepcion de los estudiantes, sus docentes y apoderados(as) acerca de las acciones realizadas en el establecimiento que promueven la construccion y el respeto de acuerdos para solucionar pacificamente conflictos, el desarrollo de habilidades de autorregulacion, dialogo y escucha.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes senalan que sus profesores(as) les ensenan a resolver conflictos de manera constructiva, ensenandoles a mantener la calma ante un problema, a pedir perdon cuando hacen dano a alguien, a hablar sobre sus sentimientos y a ponerse de acuerdo para solucionar problemas.
- **Bajo:** Los y las estudiantes senalan que sus profesores(as) no les brindan ayuda para resolver conflictos de manera constructiva, ensenandoles poco o nada a mantener la calma ante un problema, a pedir perdon cuando le hacen dano a alguien, a hablar sobre sus sentimientos y a ponerse de acuerdo para solucionar problemas.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes senalan que sus profesores(as) les ensenan a resolver conflictos de manera constructiva, ensenandoles a mantener la calma ante un problema, a pedir perdon cuando hacen dano a alguien, a hablar sobre sus sentimientos y a ponerse de acuerdo para solucionar problemas.
- **Bajo:** Los y las estudiantes senalan que sus profesores(as) no les brindan ayuda para resolver conflictos de manera constructiva, ensenandoles poco o nada a mantener la calma ante un problema, a pedir perdon cuando le hacen dano a alguien, a hablar sobre sus sentimientos y a ponerse de acuerdo para solucionar problemas.

**Existencia y uso de normas de convivencia** (Madres, padres y/o apoderados(as))  
Evalua la percepcion de madres, padres y/o apoderados(as) sobre el grado de conocimiento, respeto y claridad que tienen acerca de las normas de convivencia en la comunidad educativa.

*Niveles de desarrollo: no aplica. Subdimension no evaluada en estudiantes (actores: PAD); los niveles de desarrollo solo se reportan para EST.*

#### Ambiente seguro

Considera las percepciones de estudiantes, docentes, madres, padres y apoderados(as) en relacion al grado de seguridad y de violencia fisica y psicologica al interior del establecimiento, asi como a la existencia de mecanismos de prevencion y de accion ante esta. Ademas, considera las actitudes de los estudiantes frente al acoso escolar y a los factores que afecten su integridad fisica o psicologica.

**Mecanismos de prevencion y accion ante la violencia** (Estudiantes, Docentes, Madres, padres y/o apoderados(as))  
Evalua la percepcion que tienen los estudiantes, sus apoderados(as) y docentes acerca de las acciones y estrategias realizadas en el establecimiento para promover una cultura de buen trato, prevenir situaciones de mal trato y responder de manera oportuna y adecuada frente a situaciones de violencia.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes describen que, en el colegio, se realizan acciones de prevencion y accion ante la violencia, para que nadie se burle o amenace a otros(as), senalando que se les ensena a mantener el respeto, se les indica que hacer cuando hay peleas entre estudiantes y que la violencia es inaceptable. Ademas, se sienten seguros y seguras con las personas adultas del colegio y reconocen, al menos, una persona adulta a quien pedir ayuda si alguien los molesta o quiere hacerles dano.
- **Medio:** Los y las estudiantes describen que, en el colegio, se realizan acciones de prevencion y accion ante la violencia, para que nadie se burle o amenace a otros(as), senalando que se les ensena a respetar, se les indica que hacer cuando hay peleas entre estudiantes y que la violencia es inaceptable.
- **Bajo:** Los y las estudiantes describen que, en el colegio, no se realizan suficientes acciones de prevencion y accion ante la violencia, para evitar que alguien se burle o amenace a otros(as), senalando que no se les ensena a respetar, no se les indica que hacer cuando hay peleas entre estudiantes y no hay mensajes claros de que la violencia es inaceptable.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes describen que, en el colegio, se realizan acciones de prevencion y accion ante la violencia, para que nadie se burle o amenace a otros(as), senalando que se les ensena a mantener el respeto, se les indica que hacer cuando hay peleas entre estudiantes y que la violencia es inaceptable. Ademas, se sienten seguros y seguras con las personas adultas del colegio y reconocen, al menos, una persona adulta a quien pedir ayuda en una situacion de acoso o violencia.
- **Medio:** Los y las estudiantes describen que, en el colegio, se realizan acciones de prevencion y accion ante la violencia, para que nadie se burle o amenace a otros(as), senalando que se les ensena a respetar, se les indica que hacer cuando hay peleas entre estudiantes y que la violencia es inaceptable.
- **Bajo:** Los y las estudiantes describen que, en el colegio, no se realizan suficientes acciones de prevencion y accion ante la violencia, para evitar que alguien se burle o amenace a otros(as), senalando que no se les ensena a respetar, no se les indica que hacer cuando hay peleas entre estudiantes y no hay mensajes claros de que la violencia es inaceptable.

**Testimonios de violencia personal** (Estudiantes)  
Evalua la percepcion que tienen los estudiantes acerca de la frecuencia con que han recibido algun tipo de violencia por parte de otros(as) companeros(as), tales como burlas, exclusion, insultos o amenazas, golpes, robos, intimidacion, entre otras.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes senalan que no han sido afectados por malos tratos de parte de sus companeros(as) durante el ano, es decir, no han recibido burlas, amenazas, exclusion, violencia fisica, mal trato ni los(as) han hecho sentir mal en redes sociales.
- **Bajo:** Los y las estudiantes senalan que han sido afectados por malos tratos de parte de sus companeros(as) durante el ano, por medio de burlas, amenazas, exclusion, violencia fisica, mal trato o los(as) han hecho sentir mal en redes sociales.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes senalan que no han sido afectados por malos tratos de parte de sus companeros(as) durante el ano, es decir, no han recibido burlas, amenazas, exclusion, violencia fisica o mal trato ni los(as) han hecho sentir mal en redes sociales.
- **Bajo:** Los y las estudiantes senalan que han sido afectados por malos tratos de parte de sus companeros(as) durante el ano, a traves de burlas, amenazas, exclusion, violencia fisica, mal trato o los(as) han hecho sentir mal en redes sociales.

**Percepcion de seguridad y violencia** (Docentes, Madres, padres y/o apoderados(as))  
Evalua la percepcion de los docentes acerca de la cantidad de estudiantes del curso con conductas violentas (burlas, amenazas, golpes), junto con la percepcion de apoderados(as) sobre la frecuencia con que su hijo(a) ha sido victima de este tipo de situaciones.

*Niveles de desarrollo: no aplica. Subdimension no evaluada en estudiantes (actores: DOC, PAD); los niveles de desarrollo solo se reportan para EST.*

### Que caracteriza a un establecimiento que puntua alto en este indicador

*(Nivel indicador. Su ausencia caracteriza el nivel bajo.)*

- Fomentan un ambiente de respeto y buen trato entre todos los miembros de la comunidad educativa.
- Valoran la diversidad y la inclusion.
- Evitan y corrigen cualquier tipo de discriminacion.
- Cuentan con normas de convivencia claras y conocidas por toda la comunidad.
- Cuentan con rutinas y procedimientos que facilitan las actividades pedagogicas.
- Aplican las normas de forma justa y consistente, y corrigen de manera formativa.
- Velan por la coherencia entre los instrumentos de gestion (PEI, Reglamento Interno, Plan de gestion de la Convivencia).
- Ensenan formas pacificas y constructivas de resolver los conflictos.
- Protegen la integridad fisica y psicologica de los estudiantes.
- Previenen y enfrentan el acoso escolar o bullying de manera sistematica.
- Establecen relaciones de confianza con los estudiantes.
- Tienen un foco orientado al aprendizaje formativo y no a las sanciones disciplinarias.
- Evitan espacios donde los alumnos esten solos y sin actividad.
- Promueven actividades extraprogramaticas y en horarios libres.
- Apoyan e intervienen en cursos con mayores dificultades de convivencia.

---

## Participacion y formacion ciudadana

**Definicion.** Considera las actitudes de los estudiantes frente a su establecimiento; las percepciones de estudiantes, madres, padres y apoderados(as) sobre el grado en que la institucion fomenta la participacion y el compromiso de los miembros de la comunidad educativa; y las percepciones de los estudiantes sobre el grado en que se promueve la vida democratica.

**Como se evalua.** Cuestionarios de Calidad y Contexto de la Educacion para estudiantes, padres y apoderados. Valores cercanos a 100 para percepciones positivas y cercanos a 0 para negativas, de estudiantes y apoderados. El puntaje del indicador se calcula por ciclo, promediando los puntajes obtenidos en cada grado.

**Por que importa.** Son ejes clave para la formacion de ciudadanos integrales, con cultura civica, comprometidos y preparados para participar en su comunidad. Un clima participativo facilita los procesos educativos y contribuye al desarrollo socioemocional: mayor sentido de pertenencia, relaciones de apoyo, mejor autoestima y menos conductas de riesgo.

### Dimensiones y subdimensiones

#### Participacion

Considera las percepciones de estudiantes, madres, padres y apoderados(as) sobre las oportunidades de encuentro y espacios de colaboracion promovidos por el establecimiento, el grado de compromiso e involucramiento de los miembros de la comunidad educativa, la comunicacion desde el establecimiento hacia los apoderados, y la recepcion de inquietudes y sugerencias de parte del equipo directivo y docente.

**Participacion** (Estudiantes, Madres, padres y/o apoderados(as))  
Evalua el grado en que los estudiantes y sus apoderados(as) participan y se involucran en las actividades del colegio, informandose, participando, proponiendo y ayudando a organizar actividades de encuentro y colaboracion.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes senalan que tienen una buena participacion en el colegio, y que se informan y son parte de la mayoria de las actividades que este realiza durante el ano, proponiendo algunas y ayudando a organizarlas.
- **Medio:** Los y las estudiantes senalan que tienen una buena participacion en el colegio, y que se informan y son parte de la mayoria de las actividades que este realiza durante el ano, proponiendo algunas de estas actividades.
- **Bajo:** Los y las estudiantes senalan que tienen una baja participacion en el colegio, y que se informan y son parte solamente en algunas de las actividades que este realiza durante el ano.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes senalan que tienen una buena participacion en el colegio, y que se informan y son parte de la mayoria de las actividades que este realiza durante el ano, proponiendo algunas y ayudando a organizarlas.
- **Medio:** Los y las estudiantes senalan que tienen una buena participacion en el colegio, y que se informan y son parte de la mayoria de las actividades que este realiza durante el ano, proponiendo algunas de estas actividades.
- **Bajo:** Los y las estudiantes senalan que tienen una baja participacion en el colegio, y que se informan y son parte solamente en algunas de las actividades que este realiza durante el ano.

**Promocion de la participacion** (Estudiantes, Madres, padres y/o apoderados(as))  
Evalua la percepcion que tienen los estudiantes y sus apoderados(as) acerca de las acciones que realizan sus docentes y el colegio para incentivar la participacion en actividades de encuentro y colaboracion, informando, animando, pidiendo su ayuda y tomando en cuenta sus ideas.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben que sus profesores(as) promueven su participacion en el colegio, senalando que les informan de la mayoria de las actividades que se realizan durante el ano, los(as) animan a participar y les piden ayuda en algunas de ellas. Ademas, toman en cuenta sus ideas para llevarlas a cabo.
- **Medio:** Los y las estudiantes perciben que sus profesores(as) promueven su participacion en el colegio, senalando que les informan de la mayoria de las actividades que se realizan durante el ano, los(as) animan a participar y les piden ayuda en algunas de ellas.
- **Bajo:** Los y las estudiantes perciben que sus profesores(as) no promueven su participacion en el colegio durante el ano, senalando que les informan solamente de algunas actividades y no los(as) animan a participar ni les piden ayuda para realizarlas.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que sus profesores(as) promueven su participacion en el colegio, senalando que les informan de la mayoria de las actividades que se realizan durante el ano, los(as) animan a participar y les piden ayuda en algunas de ellas. Ademas, toman en cuenta sus ideas para llevarlas a cabo.
- **Medio:** Los y las estudiantes perciben que sus profesores(as) promueven su participacion en el colegio, senalando que les informan de la mayoria de las actividades que se realizan durante el ano, los(as) animan a participar y les piden ayuda en algunas de ellas.
- **Bajo:** Los y las estudiantes perciben que sus profesores(as) no promueven su participacion en el colegio durante el ano, senalando que les informan solamente de algunas actividades y no los(as) animan a participar ni les piden ayuda para realizarlas.

**Comunicacion con el establecimiento** (Madres, padres y/o apoderados(as))  
Evalua la percepcion que tienen madres, padres y/o apoderados(as) acerca de la cantidad, el tipo y los canales de comunicacion con el establecimiento, junto con el grado en que son escuchadas sus opiniones y sugerencias.

*Niveles de desarrollo: no aplica. Subdimension no evaluada en estudiantes (actores: PAD); los niveles de desarrollo solo se reportan para EST.*

#### Vida democratica

Considera las percepciones de los estudiantes sobre el grado en que el establecimiento fomenta el desarrollo de habilidades y actitudes necesarias para la vida en democracia: expresion de opiniones, debate fundamentado y reflexivo, valoracion y respeto hacia las opiniones de otras personas, deliberacion como mecanismo para encontrar soluciones, participacion y organizacion de procesos de representacion y votacion democratica.

**Expresion de opiniones** (Estudiantes)  
Evalua la percepcion que tienen los estudiantes acerca de su propia capacidad de respetar y escuchar las opiniones de sus companeros(as), tener sus propias opiniones, expresarlas y comunicarlas adecuadamente.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes senalan que tienen la capacidad de escuchar y respetar las opiniones de sus companeros(as) y de expresar sus propias opiniones. Ademas, indican que estan capacitados(as) para conversar con otras personas sobre sus diferentes opiniones.
- **Medio:** Los y las estudiantes senalan que tienen la capacidad de escuchar y respetar las opiniones de sus companeros(as) y de expresar sus propias opiniones.
- **Bajo:** Los y las estudiantes senalan que tienen poca capacidad de escuchar y respetar las opiniones de sus companeros(as) y de expresar sus propias opiniones.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que, en su curso, hay un ambiente propicio para expresar sus opiniones, senalando que sus profesores(as) les ensenan a respetar los distintos puntos de vista. Ademas, pueden manifestar adecuadamente su desacuerdo con ellos(as), en caso de tenerlo. Por otra parte, senalan que se les motiva a todos y todas a expresar sus puntos de vista y que pueden comunicar sus opiniones, aunque sean diferentes a las de los demas.
- **Medio:** Los y las estudiantes perciben que, en su curso, hay un ambiente propicio para expresar sus opiniones, senalando que sus profesores(as) les ensenan a respetar los distintos puntos de vista. Ademas, pueden manifestar adecuadamente su desacuerdo con ellos(as), en caso de tenerlo.
- **Bajo:** Los y las estudiantes perciben que, en su curso, no hay un ambiente propicio para expresar sus opiniones, senalando que sus profesores(as) no les ensenan a respetar los distintos puntos de vista y que no pueden manifestar su desacuerdo con ellos(as), en caso de tenerlo.

**Representacion democratica** (Estudiantes)  
Evalua la percepcion de los estudiantes respecto a la presencia en el curso de mecanismos de representacion y toma de decisiones de manera democratica.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben que en el curso hay representacion democratica, senalando que sus profesores(as) los(as) animan a elegir a sus representantes y, ademas, las opiniones del curso son escuchadas por estos y estas representantes. Junto a esto, en el curso se debaten las posiciones y se votan las decisiones.
- **Medio:** Los y las estudiantes perciben que en el curso hay representacion democratica, senalando que sus profesores(as) los(as) animan a elegir a sus representantes, y, ademas, las opiniones del curso son escuchadas por estos y estas representantes.
- **Bajo:** Los y las estudiantes perciben que en el curso no hay representacion democratica, senalando que sus profesores(as) no los(as) animan a elegir representantes y las opiniones del curso no son escuchadas por sus representantes.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que, en el curso, hay representacion democratica, senalando que el colegio los(as) anima a elegir a sus representantes, tanto del curso como del Centro de Estudiantes, quienes escuchan y toman en cuenta su opinion. Ademas, el colegio escucha las inquietudes e iniciativas de dichos representantes.
- **Medio:** Los y las estudiantes perciben que, en el curso, hay representacion democratica, senalando que el colegio los(as) anima a elegir a sus representantes, tanto del curso como del Centro de Estudiantes, quienes escuchan su opinion.
- **Bajo:** Los y las estudiantes perciben que, en el curso, no hay representacion democratica, senalando que el colegio no los(as) anima a elegir a sus representantes, ya sea del curso o del Centro de Estudiantes. Estos, a su vez, no escuchan la opinion de los y las estudiantes.

**Promocion de la deliberacion democratica** (Estudiantes)  
Evalua la percepcion de los estudiantes respecto al grado en que sus docentes fomentan la deliberacion y el dialogo como mecanismo para resolver problemas en el curso y llegar a acuerdos.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben que sus profesores(as) fomentan la deliberacion y el dialogo en el curso, los(as) ayudan a mantener la calma cuando tienen un problema y toman en cuenta sus opiniones para resolverlo. Ademas, los animan a solucionar sus problemas conversando y les brindan ayuda para llegar a acuerdos.
- **Medio:** Los y las estudiantes perciben que sus profesores(as) fomentan la deliberacion y el dialogo en el curso, los(as) ayudan a mantener la calma cuando tienen un problema y toman en cuenta sus opiniones para resolverlo.
- **Bajo:** Los y las estudiantes perciben que sus profesores(as) no fomentan la deliberacion y el dialogo en el curso, no los(as) ayudan a mantener la calma cuando tienen un problema y no toman en cuenta sus opiniones para resolverlo.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que sus profesores(as) fomentan la deliberacion y el dialogo en el curso. Ademas, los(as) ayudan a mantener la calma al enfrentar sus problemas y los(as) motivan a solucionarlos conversando. Por otra parte, les dan tiempo para reflexionar y los(as) ayudan a llegar a acuerdos que permitan solucionar los problemas.
- **Medio:** Los y las estudiantes perciben que sus profesores(as) fomentan la deliberacion y el dialogo en el curso. Ademas, los(as) ayudan a mantener la calma al enfrentar sus problemas y los(as) motivan a solucionarlos conversando.
- **Bajo:** Los y las estudiantes perciben que sus profesores(as) no fomentan la deliberacion y el dialogo en el curso. Ademas, no los(as) ayudan a mantener la calma al enfrentar sus problemas y no los(as) motivan a solucionarlos.

#### Sentido de pertenencia

Considera la identificacion de los estudiantes con el establecimiento y el orgullo que sienten de pertenecer a el. Se evalua el grado en que se identifican con el Proyecto Educativo, si se consideran parte de la comunidad escolar y si sienten orgullo de los logros de la institucion.

**Identificacion con el establecimiento** (Estudiantes)  
Evalua el grado de identificacion y afinidad que sienten los estudiantes con su establecimiento educacional, considerando aspectos formativos y pedagogicos del proyecto educativo.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes se sienten identificados con el colegio, senalando que les gusta asistir a clases, se sienten parte del colegio y hablan bien de el a otras personas. Ademas, les gustan los talleres y las actividades que realizan en el colegio y la forma que entre si se tratan los y las estudiantes.
- **Medio:** Los y las estudiantes se sienten identificados con el colegio, senalando que les gusta asistir a clases, se sienten parte del colegio y hablan bien de el a otras personas.
- **Bajo:** Los y las estudiantes no se sienten identificados con el colegio, senalando que no les gusta asistir a clases, no se sienten parte del colegio y no hablan bien de el a otras personas.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes se sienten identificados con el colegio, senalando que les gusta asistir a clases, se sienten parte del colegio y hablan bien de el a otras personas. Ademas, les gustan los talleres y las actividades que realizan en el colegio y la forma que entre si se tratan los y las estudiantes.
- **Medio:** Los y las estudiantes se sienten identificados con el colegio, senalando que les gusta asistir a clases, se sienten parte del colegio y hablan bien de el a otras personas.
- **Bajo:** Los y las estudiantes no se sienten identificados con el colegio, senalando que no les gusta asistir a clases, no se sienten parte del colegio y no hablan bien de el a otras personas.

### Que caracteriza a un establecimiento que puntua alto en este indicador

*(Nivel indicador. Su ausencia caracteriza el nivel bajo.)*

- Fomentan una identidad positiva del establecimiento.
- Organizan y fomentan actividades de encuentro entre los miembros de la comunidad educativa.
- Promueven una cultura colaborativa.
- Involucran a los miembros en el cuidado del establecimiento y de su entorno.
- Dan oportunidades para que los integrantes desarrollen iniciativas.
- Cuentan con canales efectivos de comunicacion.
- Consultan a la comunidad educativa.
- Fomentan el funcionamiento de las organizaciones representativas (Consejo Escolar, Centro de Padres, Centro de Alumnos, Consejo de Profesores).
- Promueven que los estudiantes desarrollen habilidades y actitudes para vivir en democracia.
- Promueven la organizacion de Centros de Alumnos y directivas de curso.
- Generan encuentros con apoderados.
- Potencian una relacion armonica entre profesor y estudiante.
- Cuentan con actividades extraprogramaticas: cursos y talleres.
- Promueven una cultura socioambiental.

---

## Habitos de vida saludable

**Definicion.** Evalua las actitudes y conductas autodeclaradas de los estudiantes en relacion a la vida saludable y sus percepciones sobre el grado en que el establecimiento promueve habitos beneficiosos para la salud.

**Como se evalua.** Cuestionarios de Calidad y Contexto de la Educacion para estudiantes. Valores cercanos a 100 para percepciones positivas y cercanos a 0 para negativas. El puntaje del indicador se calcula por ciclo, promediando los puntajes obtenidos en cada grado.

**Por que importa.** Contribuyen a la salud fisica y mental, a adquirir habilidades sociales y al proceso de ensenanza-aprendizaje. Su desarrollo temprano tiene consecuencias para la vida escolar y adulta; ayudan a la concentracion y disminuyen ansiedad y estres.

### Dimensiones y subdimensiones

#### Habitos alimenticios

Considera las actitudes y conductas autodeclaradas de los estudiantes hacia la alimentacion, y sus percepciones sobre el grado en que el establecimiento promueve habitos de alimentacion sana.

**Actitud frente a la alimentacion** (Estudiantes)  
Evalua la percepcion que tienen los estudiantes acerca de la importancia que tiene para su salud mantener buenos habitos y evitar malos habitos de alimentacion.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes tienen una actitud favorable frente a la alimentacion, senalando que es importante para su salud evitar la comida chatarra y las golosinas, asi como comer fuera de horario. Ademas, consideran relevante alimentarse al menos tres veces al dia e hidratarse adecuadamente. Por otra parte, perciben que es importante para su salud consumir frutas y verduras regularmente y evitar comer en exceso.
- **Medio:** Los y las estudiantes tienen una actitud favorable frente a la alimentacion, senalando que es importante para su salud evitar la comida chatarra y las golosinas, asi como comer fuera de horario. Ademas, consideran relevante alimentarse al menos tres veces al dia e hidratarse adecuadamente.
- **Bajo:** Los y las estudiantes tienen una actitud desfavorable frente a la alimentacion, senalando que es poco importante para su salud evitar la comida chatarra y las golosinas, asi como comer fuera de horario. Ademas, consideran irrelevante alimentarse al menos tres veces al dia e hidratarse adecuadamente.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes tienen una actitud favorable frente a la alimentacion, senalando que es importante para su salud evitar la comida chatarra y las golosinas, asi como comer fuera de horario. Ademas, consideran relevante alimentarse al menos tres veces al dia e hidratarse adecuadamente. Por otra parte, perciben que es importante para su salud consumir frutas y verduras regularmente, y evitar comer en exceso.
- **Medio:** Los y las estudiantes tienen una actitud favorable frente a la alimentacion, senalando que es importante para su salud evitar la comida chatarra y las golosinas, asi como comer fuera de horario. Ademas, consideran relevante alimentarse al menos tres veces al dia e hidratarse adecuadamente.
- **Bajo:** Los y las estudiantes tienen una actitud desfavorable frente a la alimentacion, senalando que es poco importante para su salud evitar la comida chatarra y las golosinas, asi como comer fuera de horario. Ademas, consideran irrelevante alimentarse al menos tres veces al dia e hidratarse adecuadamente.

**Promocion de habitos alimenticios** (Estudiantes)  
Evalua la percepcion de los estudiantes acerca de la educacion que reciben en el establecimiento sobre buenos habitos alimenticios y los riesgos para la salud de malos habitos alimenticios.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben que, en su colegio, les ensenan a tener buenos habitos de alimentacion y les explican los riesgos que las malas rutinas alimenticias tienen para su salud. Ademas, senalan que, en el colegio, se realizan talleres y campanas para promover la alimentacion saludable.
- **Bajo:** Los y las estudiantes perciben que, en su colegio, no les ensenan a tener buenos habitos de alimentacion ni les explican los riesgos que las malas rutinas alimenticias tienen para su salud.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que, en su colegio, les ensenan a tener buenos habitos de alimentacion y les explican los riesgos que las malas rutinas alimenticias tienen para su salud. Ademas, senalan que, en el colegio, se realizan talleres y campanas para promover la alimentacion saludable.
- **Bajo:** Los y las estudiantes perciben que, en su colegio, no les ensenan a tener buenos habitos de alimentacion ni les explican los riesgos que las malas rutinas alimenticias tienen para su salud.

#### Habitos de vida activa

Considera las actitudes y conductas autodeclaradas de los estudiantes hacia un estilo de vida activo, y sus percepciones sobre el grado en que el establecimiento fomenta la actividad fisica.

**Actitud frente a la actividad fisica** (Estudiantes)  
Evalua la percepcion que tienen los estudiantes acerca de la importancia que tiene para su salud realizar actividad fisica y deportes de manera regular, junto con la identificacion de los riesgos del sedentarismo y el exceso en el uso de pantallas.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes tienen una actitud favorable a la actividad fisica, senalando que es importante jugar y moverse durante el recreo. Perciben el riesgo que tiene para su salud pasar mucho tiempo frente a una pantalla viendo el celular, jugando videojuegos o viendo television. Ademas, les parece importante hacer actividad fisica los fines de semana y despues del colegio los dias de semana.
- **Medio:** Los y las estudiantes tienen una actitud favorable a la actividad fisica, senalando que es importante jugar y moverse durante el recreo. Perciben el riesgo que tiene para su salud pasar mucho tiempo frente a una pantalla viendo el celular, jugando videojuegos o viendo television.
- **Bajo:** Los y las estudiantes tienen una actitud desfavorable a la actividad fisica, senalando que es poco o nada importante jugar y moverse durante el recreo. No perciben el riesgo que tiene para su salud pasar mucho tiempo frente a una pantalla viendo el celular, jugando videojuegos o viendo television.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes tienen una actitud favorable a la actividad fisica, senalando que les parece importante practicarla, asi como hacer ejercicio, al menos tres veces a la semana, y evitar pasar mucho tiempo frente a una pantalla viendo el celular, jugando videojuegos o viendo television. Ademas, les parece importante practicar deporte en talleres u otras instancias durante el fin de semana.
- **Medio:** Los y las estudiantes tienen una actitud favorable a la actividad fisica, senalando que les parece importante practicarla, asi como hacer ejercicio, al menos tres veces a la semana, y evitar pasar mucho tiempo frente a una pantalla viendo el celular, jugando videojuegos o viendo television.
- **Bajo:** Los y las estudiantes tienen una actitud desfavorable a la actividad fisica, senalando que les parece poco o nada importante practicarla, asi como hacer ejercicio, al menos tres veces a la semana. Ademas, no consideran que sea un riesgo pasar mucho tiempo frente a una pantalla viendo el celular, jugando videojuegos o viendo television.

**Promocion de vida activa** (Estudiantes)  
Evalua la percepcion de los estudiantes acerca de la educacion que reciben en el establecimiento en relacion a la actividad fisica y el deporte.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben que, en su colegio, se promociona la vida activa, senalando que les ensenan los beneficios que conlleva para la salud realizar actividad fisica. Ademas, senalan que les animan a realizar actividad fisica y deporte en talleres del colegio o lugares fuera de el.
- **Bajo:** Los y las estudiantes perciben que, en su colegio, no se promociona la vida activa, senalando que no les ensenan los beneficios que conlleva para la salud realizar actividad fisica. Ademas, senalan que no les animan a realizar actividad fisica y deporte en talleres del colegio ni en lugares fuera de el.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que, en su colegio, se promociona la vida activa, senalando que les ensenan los beneficios que conlleva para la salud realizar actividad fisica. Ademas, senalan que les animan a realizar actividad fisica y deporte en talleres del colegio o lugares fuera de el.
- **Bajo:** Los y las estudiantes perciben que, en su colegio, no se promociona la vida activa, senalando que no les ensenan los beneficios que conlleva para la salud realizar actividad fisica. Ademas, senalan que no les animan a realizar actividad fisica y deporte en talleres del colegio ni en lugares fuera de el.

#### Habitos de autocuidado

Considera las actitudes y conductas autodeclaradas de los estudiantes ante la sexualidad y frente al consumo de tabaco, alcohol y drogas, y sus percepciones sobre el grado en que el establecimiento previene conductas de riesgo y promueve conductas de autocuidado e higiene.

**Actitud de autocuidado** (Estudiantes)  
Evalua la percepcion que tienen los estudiantes acerca de los riesgos que tiene para su salud el consumo de alcohol, tabaco y drogas y dormir menos de las horas recomendadas para su edad.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes tienen una actitud favorable al autocuidado, senalando que es peligroso fumar cigarros, beber alcohol y consumir drogas para la salud de personas de su edad. Ademas, consideran que es danino dormir menos de ocho horas por la noche.
- **Medio:** Los y las estudiantes tienen una actitud favorable al autocuidado, senalando que es peligroso fumar cigarros, beber alcohol y consumir drogas para la salud de las personas de su edad.
- **Bajo:** Los y las estudiantes tienen una actitud desfavorable al autocuidado, senalando que es poco o nada peligroso fumar cigarros, beber alcohol y consumir drogas para la salud de las personas de su edad.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes tienen una actitud favorable al autocuidado, senalando que es peligroso fumar cigarros, beber alcohol, fumar marihuana y consumir otras drogas para la salud de las personas de su edad. Ademas, consideran que es danino dormir menos de siete horas por la noche.
- **Medio:** Los y las estudiantes tienen una actitud favorable al autocuidado, senalando que es peligroso fumar cigarros, beber alcohol, fumar marihuana y consumir otras drogas para la salud de las personas de su edad.
- **Bajo:** Los y las estudiantes tienen una actitud desfavorable al autocuidado, senalando que es poco o nada peligroso fumar cigarros, beber alcohol, fumar marihuana o consumir otras drogas para la salud de las personas de su edad.

**Promocion de conductas de autocuidado** (Estudiantes)  
Evalua la percepcion de los estudiantes acerca de la educacion que reciben en el establecimiento sobre el peligro del consumo de alcohol, tabaco y drogas, junto con el cuidado del cuerpo.

*Niveles de desarrollo (4 y 6 basico):*

- **Alto:** Los y las estudiantes perciben que, en su colegio, se promueven conductas de autocuidado, senalando que les ensenan los problemas que causa fumar cigarros, beber alcohol y consumir drogas. Ademas, les ensenan que nadie debe tocar o ver las partes intimas del cuerpo.
- **Bajo:** Los y las estudiantes perciben que, en su colegio, no se promueven conductas de autocuidado, senalando que no les ensenan los problemas que causa fumar cigarros, beber alcohol y consumir drogas. Ademas, no les ensenan que nadie debe tocar o ver las partes intimas de su cuerpo.

*Niveles de desarrollo (II medio):*

- **Alto:** Los y las estudiantes perciben que, en su colegio, se promueven conductas de autocuidado, senalando que les ensenan los problemas que causa fumar cigarros, beber alcohol y consumir drogas. Tambien les ensenan que nadie debe tocar las partes intimas del cuerpo de una persona sin su permiso y los riesgos de tener relaciones sexuales sin usar proteccion.
- **Bajo:** Los y las estudiantes perciben que, en su colegio, no se promueven conductas de autocuidado, senalando que no les ensenan acerca de los problemas que causa fumar cigarros, beber alcohol y consumir drogas. Tampoco les ensenan que nadie debe tocar las partes intimas del cuerpo de una persona sin su permiso ni los riesgos de tener relaciones sexuales sin usar proteccion.

### Que caracteriza a un establecimiento que puntua alto en este indicador

*(Nivel indicador. Su ausencia caracteriza el nivel bajo.)*

- Crean conciencia sobre la importancia de una alimentacion equilibrada, una vida activa y buenos habitos de sueno.
- Profundizan los contenidos curriculares relacionados con la vida saludable.
- Ofrecen alimentos saludables en quioscos y casinos (Ley 20.606).
- Incentivan el consumo de agua.
- Prefieren incentivos no comestibles.
- Ofrecen facilidades para la actividad fisica.
- Destinan tiempo significativo de Educacion Fisica al acondicionamiento de todos los estudiantes.
- Educan tempranamente y con el ejemplo sobre los riesgos de tabaco, alcohol y drogas.
- Desarrollan habilidades que sirven como factores protectores.
- Ofrecen programas de prevencion de consumo y apoyan a quienes presentan consumo problematico.
- Entregan educacion sexual.
- Involucran a los padres en el desarrollo de habitos de vida saludable.
- Ofrecen charlas educativas para estudiantes.
- Realizan recreos activos y entretenidos.
- Comunican preocupacion por las condiciones sanitarias y de seguridad del local escolar.
- Promueven actividades pedagogicas fuera del aula y el contacto con espacios naturales.

---

# Glosario

- **Actividades de encuentro y colaboracion:** Instancias que favorecen la cercania y el intercambio entre los miembros de una comunidad educativa, a traves de actividades recreativas, deportivas, culturales, solidarias u otras, promovidas por el establecimiento.
- **Autovaloracion academica:** Juicios y sentimientos del estudiante asociados al autoconcepto academico, tales como satisfaccion, orgullo o suficiencia en el ambito escolar.
- **Buen trato:** Forma particular de relacion interpersonal inspirada en el resguardo de los derechos humanos y la dignidad de las personas. Se caracteriza por empatia, comunicacion efectiva, respeto y colaboracion.
- **Deliberacion para la resolucion de conflictos:** Mecanismo de dialogo y expresion de opiniones que busca la construccion pacifica de acuerdos para solucionar conflictos.
- **Mecanismos constructivos de resolucion de conflictos:** Estilo de resolver los conflictos desde un enfoque formativo, comprendiendolos como oportunidad para desarrollar habilidades sociales (dialogo, escucha, colaboracion).
- **Percepcion:** Proceso cognitivo mediante el cual las personas construyen representaciones mentales de ciertos objetos a partir de su experiencia y participacion en un contexto especifico.
- **Relaciones interpersonales:** Interacciones entre las personas que pertenecen a una misma comunidad educativa: comunicacion, coordinacion de acciones y construccion de intersubjetividades que dan forma a la cultura escolar.
- **Relaciones sociales:** Interacciones o vinculos que se establecen entre las personas en distintos contextos (familia, escuela, comunidad), fundamentales para el bienestar emocional, el aprendizaje y el desarrollo personal.
