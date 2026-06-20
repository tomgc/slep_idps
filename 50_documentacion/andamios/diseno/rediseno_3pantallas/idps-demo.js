/* ============================================================
   Motor IDPS — prototipo navegable (vanilla JS + SVG)
   Tres pantallas:
     1) Panorama territorial   (#screen-territorio)  — default SLEP Costa Central
     2) Panorama IDPS por establecimiento (#screen-ficha)
     3) Comparación entre territorios (#screen-comparar)
   Datos ILUSTRATIVOS, deterministas. No es pipeline real.
   Paleta oficial de indicadores (Agencia de Calidad):
     Autoestima #23519C · Convivencia #45B9C3 · Participación #009443 · Hábitos #ACC71A
   Estado vs GSE (sin semáforo):
     bajo #EE2D49 · sin diferencia #8C8A86 · sobre #2A8FD9
   ============================================================ */
"use strict";
(function () {

/* ---------- color helpers ---------- */
function hx(h){h=h.replace('#','');return [parseInt(h.slice(0,2),16),parseInt(h.slice(2,4),16),parseInt(h.slice(4,6),16)];}
function toHex(a){return '#'+a.map(v=>Math.max(0,Math.min(255,Math.round(v))).toString(16).padStart(2,'0')).join('');}
function mix(a,b,t){const A=hx(a),B=hx(b);return toHex(A.map((v,i)=>v+(B[i]-v)*t));}
const lighten=(h,t)=>mix(h,'#ffffff',t), darken=(h,t)=>mix(h,'#000000',t);
function textOn(h){const [r,g,b]=hx(h);const L=(0.299*r+0.587*g+0.114*b)/255;return L>0.60?'#1C1212':'#ffffff';}

/* ---------- Marco conceptual ---------- */
const IND = [
  { id:"autoestima", n:1, color:"#23519C", nombre:"Autoestima académica y motivación escolar", corto:"Autoestima y motivación",
    def:"Autopercepción del estudiante sobre su capacidad de aprender y sus actitudes hacia el estudio.",
    alto:"Sus estudiantes confían en sus aptitudes, valoran lo académico y persisten ante las dificultades.",
    dims:[
      { id:"autopercepcion", nombre:"Autopercepción y autovaloración académica", corto:"Autopercepción académica",
        subs:["Percepción de aptitudes propias","Valoración de habilidades por asignatura"] },
      { id:"motivacion", nombre:"Motivación escolar", corto:"Motivación escolar",
        subs:["Interés por aprender","Actitud ante las dificultades"] },
    ] },
  { id:"convivencia", n:2, color:"#45B9C3", nombre:"Clima de convivencia escolar", corto:"Convivencia escolar",
    def:"Percepción de un ambiente de respeto, organizado y seguro en el establecimiento.",
    alto:"Hay trato respetuoso, normas claras y conocidas, y ausencia de violencia; los conflictos se resuelven bien.",
    dims:[
      { id:"respeto", nombre:"Ambiente de respeto", corto:"Ambiente de respeto",
        subs:["Trato respetuoso","Valoración de la diversidad","Ausencia de discriminación"] },
      { id:"organizado", nombre:"Ambiente organizado", corto:"Ambiente organizado",
        subs:["Normas claras y conocidas","Resolución constructiva de conflictos"] },
      { id:"seguro", nombre:"Ambiente seguro", corto:"Ambiente seguro",
        subs:["Ausencia de violencia","Mecanismos de prevención"] },
    ] },
  { id:"participacion", n:3, color:"#009443", nombre:"Participación y formación ciudadana", corto:"Participación ciudadana",
    def:"Actitudes frente al establecimiento y fomento de la vida democrática y el compromiso cívico.",
    alto:"Ofrecen espacios de participación, representación estudiantil y un fuerte sentido de pertenencia.",
    dims:[
      { id:"participacion_d", nombre:"Participación", corto:"Participación",
        subs:["Espacios de encuentro","Colaboración y comunicación"] },
      { id:"democratica", nombre:"Vida democrática", corto:"Vida democrática",
        subs:["Expresión de opiniones","Representación estudiantil"] },
      { id:"pertenencia", nombre:"Sentido de pertenencia", corto:"Sentido de pertenencia",
        subs:["Identificación con el establecimiento","Orgullo de pertenecer"] },
    ] },
  { id:"habitos", n:4, color:"#ACC71A", nombre:"Hábitos de vida saludable", corto:"Vida saludable",
    def:"Actitudes y conductas autodeclaradas sobre una vida saludable y su promoción.",
    alto:"Promueven alimentación saludable, vida activa y autocuidado, con conductas preventivas instaladas.",
    dims:[
      { id:"alimenticios", nombre:"Hábitos alimenticios", corto:"Hábitos alimenticios",
        subs:["Actitud frente a la alimentación","Promoción institucional"] },
      { id:"activa", nombre:"Hábitos de vida activa", corto:"Vida activa",
        subs:["Actitud frente a la actividad física","Promoción del deporte"] },
      { id:"autocuidado", nombre:"Hábitos de autocuidado", corto:"Autocuidado",
        subs:["Consumo de sustancias","Conductas de autocuidado"] },
    ] },
];
const INDByDim = {};
IND.forEach(i => i.dims.forEach(d => { d.indId=i.id; d.color=i.color; d.n=i.n; INDByDim[d.id]=i; }));
// tonos derivados, coherentes con el color madre
function dimColor(mother, di, total){ const t = total<=1?0.5: di/(total-1); const f=-0.05 + t*0.40; return f<0?darken(mother,-f):lighten(mother,f); }
function subColor(dimc, si){ return lighten(dimc, 0.16 + si*0.13); }

const GSE = [
  { cod:1, label:"GSE 1 · Bajo", corto:"Bajo" },
  { cod:2, label:"GSE 2 · Medio bajo", corto:"Medio bajo" },
  { cod:3, label:"GSE 3 · Medio", corto:"Medio" },
  { cod:4, label:"GSE 4 · Medio alto", corto:"Medio alto" },
  { cod:5, label:"GSE 5 · Alto", corto:"Alto" },
];
const gseCorto = c => GSE.find(g=>g.cod===c).corto;
const NIVELES = [{ id:"4b", label:"4° básico" }, { id:"2m", label:"2° medio" }];
const C_BAJO="#EE2D49", C_NEUTRO="#8C8A86", C_SOBRE="#2A8FD9", CC_AZUL="#0062A0";

/* ---------- Generador determinista ---------- */
const clamp = (x)=>Math.max(2,Math.min(100,Math.round(x)));
function hash(str){ let h=2166136261; for(let i=0;i<str.length;i++){ h^=str.charCodeAt(i); h=Math.imul(h,16777619);} return (h>>>0)/4294967295; }
function score(key){ return clamp(38 + hash("v|"+key)*54); }
function gseDelta(key){ return Math.round((hash("g|"+key)-0.5)*40); }
function yearDelta(key){ return Math.round((hash("y|"+key)-0.5)*36); }
function sig(key, delta){ const thr = 6 + hash("t|"+key)*5; return Math.abs(delta) >= thr; }
function ancla(key){
  const v = score(key);
  const gd = gseDelta(key), gs = sig("gse|"+key, gd);
  const yd = yearDelta(key), ys = sig("yr|"+key, yd);
  const noData = hash("nd|"+key) < 0.05;
  const gseRef = clamp(v - gd);
  let estado = "neutro"; if (gs && gd<0) estado="bajo"; else if (gs && gd>0) estado="sobre";
  return { v, gd, gs, yd, ys, noData, gseRef, estado };
}

/* ============================================================
   Radar SVG — SOLO indicadores (4 ejes). Escala fija 0–100.
   ============================================================ */
function radar({ size=300, axes, series, vlabels }){
  const m = vlabels?30:16;
  const W=size, H=size, cx=W/2, cy=H/2, R=(size/2)-m, N=axes.length;
  const ang=i=>(-Math.PI/2)+i*(2*Math.PI/N);
  const pt=(i,val)=>{const r=R*(Math.max(0,Math.min(100,val))/100);return [cx+r*Math.cos(ang(i)), cy+r*Math.sin(ang(i))];};
  let s=`<svg viewBox="0 0 ${W} ${H}" width="100%" height="100%" class="radar-svg" role="img">`;
  [25,50,75,100].forEach(rr=>{ const poly=axes.map((_,i)=>pt(i,rr).join(",")).join(" "); s+=`<polygon points="${poly}" fill="none" stroke="#E7DFC9" stroke-width="1"/>`; });
  axes.forEach((a,i)=>{ const [x,y]=pt(i,100); s+=`<line x1="${cx}" y1="${cy}" x2="${x}" y2="${y}" stroke="#EFE6CE" stroke-width="1"/>`; });
  series.forEach(se=>{
    const poly=axes.map((_,i)=>pt(i,se.points[i]).join(",")).join(" ");
    s+=`<polygon points="${poly}" fill="${se.fill||'none'}" stroke="${se.stroke}" stroke-width="${se.w||2}" ${se.dashed?'stroke-dasharray="5 4"':''} stroke-linejoin="round"/>`;
    axes.forEach((a,i)=>{ const [x,y]=pt(i,se.points[i]); const c=se.vertexByAxis?a.color:se.stroke; s+=`<circle cx="${x}" cy="${y}" r="${se.dot||4}" fill="${c}" stroke="#fff" stroke-width="1.2"/>`; });
  });
  if(vlabels){ axes.forEach((a,i)=>{ const L=vlabels[i]; const [x,y]=pt(i,106); const anchor=Math.abs(x-cx)<6?'middle':(x>cx?'start':'end'); const dy=y<cy-4?2:(y>cy+4?12:5); const fs=L.fs||14;
    s+=`<text x="${x}" y="${y+dy}" text-anchor="${anchor}" style="paint-order:stroke" stroke="#fff" stroke-width="3.4"><tspan fill="${L.c}" font-weight="800" font-size="${fs}">${L.t}</tspan>${L.s?` <tspan fill="${L.sc}" font-weight="800" font-size="${fs-3}">${L.s}</tspan>`:''}</text>`; }); }
  return s+`</svg>`;
}

/* ---------- stat (ancla) — NO clickeable: icono de color + texto ---------- */
function stat(label, delta, sigFlag, noData, tiny){
  const t = tiny?" tiny":"";
  if (noData) return `<span class="stat${t}"><span class="stat-ic st-nd">–</span><span class="stat-tx">${label}: <b>sin dato</b></span></span>`;
  const up=delta>0, k=!sigFlag?"eq":(up?"up":"down"), gly=!sigFlag?"=":(up?"▲":"▼");
  const sd=delta>0?("+"+delta):(""+delta);
  return `<span class="stat${t}"><span class="stat-ic st-${k}">${gly}</span><span class="stat-tx">${label}: <b>${sd}</b> · ${sigFlag?"significativo":"no significativo"}</span></span>`;
}

/* ---------- barra 0–100 con referencia GSE ("GSE n puntos") ---------- */
function bar0100({ value, gseRef, color, noGse, h }){
  let gse="";
  if(!noGse){
    const align = gseRef>72?"right":(gseRef<24?"left":"center");
    const tf = align==="right"?"translateX(-100%)":(align==="left"?"translateX(0)":"translateX(-50%)");
    gse=`<span class="bar-gse" style="left:${gseRef}%"><span class="bar-gse-line"></span><span class="bar-gse-cap" style="transform:${tf}">GSE ${gseRef} puntos</span></span>`;
  }
  return `<div class="bar" style="--bh:${h||26}px"><div class="bar-track"><div class="bar-fill" style="width:${value}%;background:${color}"></div>${gse}</div></div>`;
}

/* ---------- leyenda estándar (idéntica en las 3 pantallas) ---------- */
function legendStd(){
  return `<div class="cmp-legend">
      <span class="cl-i"><span class="cl-sw" style="background:${C_BAJO}"></span>▼ bajo su GSE</span>
      <span class="cl-i"><span class="cl-sw" style="background:${C_NEUTRO}"></span>= sin diferencia</span>
      <span class="cl-i"><span class="cl-sw" style="background:${C_SOBRE}"></span>▲ sobre su GSE</span>
    </div>`;
}

/* ---------- stacked 100% (% n) ---------- */
function pctRound(parts){ // redondea a enteros sumando 100, preservando el orden
  const total=parts.reduce((a,b)=>a+b.count,0)||1;
  const out=parts.map((p)=>({...p, raw:p.count/total*100}));
  out.forEach(p=>p.p=Math.floor(p.raw)); let rem=100-out.reduce((a,b)=>a+b.p,0);
  const order=[...out].sort((a,b)=>(b.raw-b.p)-(a.raw-a.p)); for(let i=0;i<rem;i++) order[i%order.length].p++;
  return out;
}
function stacked100(rep, compact){
  const parts=pctRound([{k:"bajo",c:C_BAJO,count:rep.bajo},{k:"neutro",c:C_NEUTRO,count:rep.neutro},{k:"sobre",c:C_SOBRE,count:rep.sobre}]);
  const cls = compact?" compact":"";
  return `<div class="s100${cls}">`+parts.map(s=>{
    const lab = compact ? (s.p>=18?`${s.p}%`:"") : (s.p>=16?`${s.p}% (${s.count})`:(s.p>=9?`${s.p}%`:""));
    return `<div class="s100-seg s-${s.k}" style="width:${s.p}%" title="${s.k==='bajo'?'bajo su GSE':s.k==='sobre'?'sobre su GSE':'sin diferencia'}: ${s.count} de ${rep.N} (${s.p}%)">${lab?`<span>${lab}</span>`:""}</div>`;
  }).join("")+`</div>`;
}

/* ============================================================
   Territorios y establecimientos
   ============================================================ */
const TERR = [
  { id:"costacentral", nombre:"SLEP Costa Central", meta:"4 comunas · 60 establecimientos", color:CC_AZUL },
  { id:"valparaiso",   nombre:"SLEP Valparaíso",    meta:"2 comunas · 41 establecimientos", color:"#4A2746" },
  { id:"andalien",     nombre:"SLEP Andalién Sur",  meta:"3 comunas · 69 establecimientos", color:"#E88663" },
  { id:"region05",     nombre:"Región de Valparaíso", meta:"38 comunas · 612 establecimientos", color:"#BCA493" },
];
const ESTAB_POOL = [
  ["Colegio Artístico Costa Mauco","Quintero","1631"],["Complejo Educacional Sargento Aldea","Puchuncaví","1702"],
  ["Escuela Arturo Prat Chacón","Viña del Mar","1845"],["Escuela Básica El Rincón","Puchuncaví","1912"],
  ["Escuela Villa Independencia","Concón","2033"],["Liceo Bicentenario Costa","Viña del Mar","2141"],
  ["Escuela Las Salinas","Viña del Mar","2256"],["Colegio Mar de Chile","Concón","2370"],
  ["Escuela Bosques de Montemar","Concón","2489"],["Liceo Politécnico Quintero","Quintero","2512"],
  ["Escuela Valle Alegre","Puchuncaví","2634"],["Colegio Santa María del Mar","Viña del Mar","2741"],
];
function nEstab(terrId, gse){ return 6 + Math.floor(hash("ne|"+terrId+"|"+gse)*7); } // 6..12
function estabsDe(terrId, gse){ const N=nEstab(terrId,gse); return ESTAB_POOL.slice(0,N).map((e,k)=>({ key:terrId+"|"+gse+"|e"+k, nombre:e[0], comuna:e[1], rbd:e[2] })); }
const estName = (nombre, rbd)=>`${nombre} (RBD ${rbd})`;
function levelsOf(key){ const r=hash("lv|"+key); return { b4: r<0.8, m2: r>0.3 }; }
function defaultNivel(key){ return levelsOf(key).b4?"4b":"2m"; }

/* ============================================================
   ESTADO de navegación
   ============================================================ */
const app = {
  screen:"territorio",
  panTerr:"costacentral", panGseVis:new Set([1,2,3,4,5]), panNivel:"4b",
  ficha:{ key:"costacentral|1|seed", nombre:"Colegio Artístico Costa Mauco (RBD 1631)", comuna:"Quintero", rbd:"1631", gse:1, nivel:defaultNivel("costacentral|1|seed"), terr:"SLEP Costa Central", view:"actual" },
  cmpNivel:"4b", cmpGseVis:new Set([1,2,3,4,5]),
};

function show(screen){ app.screen=screen; document.querySelectorAll(".screen").forEach(s=>s.classList.toggle("on", s.id==="screen-"+screen));
  document.querySelectorAll(".nav-item").forEach(n=>n.classList.toggle("on", n.dataset.screen===screen));
  window.scrollTo({top:0,behavior:"instant"}); render(); }

/* ============================================================
   PANTALLA 1 — Panorama territorial
   ============================================================ */
function repartoEstab(terrId, gse, indId){
  const ests = estabsDe(terrId, gse); let bajo=0,neutro=0,sobre=0;
  ests.forEach(e=>{ const a=ancla(e.key+"|"+indId); if(a.estado==="bajo")bajo++; else if(a.estado==="sobre")sobre++; else neutro++; });
  return { bajo, neutro, sobre, N:ests.length };
}
function miniRadar(estKey){
  const data=IND.map(i=>{ const a=ancla(estKey+"|"+i.id); return {a, color:i.color}; });
  const axes=IND.map(i=>({color:i.color}));
  const vlabels=data.map(d=>{ const st=d.a.estado, sc=st==="bajo"?C_BAJO:(st==="sobre"?C_SOBRE:C_NEUTRO), gly=st==="bajo"?"▼":(st==="sobre"?"▲":"="); return { t:String(d.a.v), c:d.color, s:`(${gly} ${d.a.gd>0?'+':''}${d.a.gd})`, sc, fs:12 }; });
  return radar({ size:210, axes, vlabels, series:[
    {points:data.map(d=>d.a.gseRef), stroke:"#B7AC96", w:1.4, dashed:true, dot:2.5},
    {points:data.map(d=>d.a.v), stroke:"#0A3A5C", fill:"rgba(10,58,92,.07)", vertexByAxis:true, dot:5}
  ]});
}
function renderTerritorio(){
  const root=document.getElementById("screen-territorio"); if(!root) return;
  const terr=TERR.find(t=>t.id===app.panTerr);
  const nivelLab=NIVELES.find(n=>n.id===app.panNivel).label;
  const terrOpts=TERR.map(t=>`<option value="${t.id}" ${t.id===app.panTerr?"selected":""}>${t.nombre}</option>`).join("");
  const gseFilter=GSE.map(g=>`<button class="gfb ${app.panGseVis.has(g.cod)?'on':''}" data-pangse="${g.cod}"><span class="gf-check">${app.panGseVis.has(g.cod)?'✓':''}</span>${g.corto}</button>`).join("");
  const nivelSeg=NIVELES.map(n=>`<button class="lvl-b ${app.panNivel===n.id?'on':''}" data-pannivel="${n.id}">${n.label}</button>`).join("");

  const visGse=GSE.filter(g=>app.panGseVis.has(g.cod));
  const sections=visGse.map(g=>{
    const gse=g.cod;
    const dist=IND.map(i=>{ const rep=repartoEstab(terr.id,gse,i.id); return `<div class="pan-dist-row"><div class="pan-dist-lab"><span class="sw" style="background:${i.color}"></span>${i.nombre}</div>${stacked100(rep)}</div>`; }).join("");
    const ests=estabsDe(terr.id,gse);
    const cards=ests.map(e=>{ const bajos=IND.filter(i=>ancla(e.key+"|"+i.id).estado==="bajo").length, sobres=IND.filter(i=>ancla(e.key+"|"+i.id).estado==="sobre").length;
      const pill=bajos>=sobres?`<span class="gc-pill is-bajo">▼ ${bajos} indicadores bajo su GSE</span>`:`<span class="gc-pill is-sobre">▲ ${sobres} indicadores sobre su GSE</span>`;
      return `<button class="gcard" data-estab="${e.key}" data-gse="${gse}" data-nombre="${e.nombre}" data-comuna="${e.comuna}" data-rbd="${e.rbd}"><div class="gc-name">${estName(e.nombre,e.rbd)}</div><div class="gc-meta">${e.comuna} · SLEP Costa Central</div><div class="gc-radar">${miniRadar(e.key)}</div><div class="gc-foot">${pill}<span class="gc-go">ver más detalles →</span></div></button>`;
    }).join("");
    return `<section class="gse-sec pan-sec"><div class="gse-sec-h"><span class="gse-sec-name">${g.corto}</span><span class="gse-sec-sub">${ests.length} establecimientos · grupo socioeconómico</span></div>
      <div class="pan-gse-body">
        <div class="block-h sub">Distribución por estado vs su GSE</div>
        <div class="pan-dist">${dist}</div>
        <div class="block-h sub" style="margin-top:20px">Establecimientos <span class="block-sub">· clic para ver el Panorama IDPS del establecimiento</span></div>
        <div class="pan-grid">${cards}</div>
      </div></section>`;
  }).join("") || `<div class="cmp2-empty">Selecciona al menos un grupo socioeconómico (GSE) en el segmentador de arriba.</div>`;

  root.innerHTML=`
    <div class="pan-bar">
      <div class="pan-id"><div class="pan-name">${terr.nombre}</div><div class="pan-meta">${terr.meta} · ${nivelLab} · ${visGse.length} de 5 GSE · 2025 (preliminar)</div></div>
      <div class="pan-nivel"><div class="nivelsel"><span class="nivelsel-lab">Nivel</span><div class="seg-lvl big">${nivelSeg}</div></div></div>
    </div>
    <div class="picker-bar">
      <span class="picker-lab">Territorio</span>
      <div class="picker-ctl"><div class="terr-select"><select id="pan-terr">${terrOpts}</select><span class="ts-ic">▾</span></div></div>
    </div>
    <div class="gse-filter-wrap">
      <span class="cmp-cl">Grupo socioeconómico (GSE)</span>
      <span class="gse-filter-note">Muestra u oculta cada grupo; selecciona los que quieras, incluso todos.</span>
      <div class="gse-filter">${gseFilter}</div>
    </div>
    <div class="pan-explain"><b>Panorama del territorio sin agregar.</b> El territorio acota la lista de establecimientos; no produce un puntaje propio. Por cada GSE: cómo se reparten sus establecimientos por estado vs su GSE, y la grilla para abrir el panorama IDPS de cada uno.</div>
    ${legendStd()}
    ${sections}`;
}

/* ============================================================
   PANTALLA 2 — Panorama IDPS por establecimiento (ficha)
   ============================================================ */
/* buscador de establecimientos */
const SEARCH_POOL = ESTAB_POOL.map((e,idx)=>({ idx, key:"search|"+idx, nombre:e[0], comuna:e[1], rbd:e[2], terr:"SLEP Costa Central", gse:1+(idx%5) }));
function renderEstabResults(q){
  const box=document.getElementById("estab-results"); if(!box) return;
  q=(q||"").trim().toLowerCase();
  if(!q){ box.classList.remove("open"); box.innerHTML=""; return; }
  const res=SEARCH_POOL.filter(e=>(e.nombre+" "+e.comuna+" rbd "+e.rbd).toLowerCase().includes(q)).slice(0,8);
  box.innerHTML = res.length
    ? res.map(e=>`<button class="estab-opt" data-pidx="${e.idx}"><span class="eo-n">${estName(e.nombre,e.rbd)}</span><span class="eo-m">${e.comuna} · ${e.terr} · GSE ${gseCorto(e.gse)}</span></button>`).join("")
    : `<div class="estab-empty">Sin resultados.</div>`;
  box.classList.add("open");
}
/* serie histórica + line chart */
const ANIOS = { "4b":[2022,2023,2025], "2m":[2022,2023,2024,2025] };
const PRELIM = 2025;
function valYear(key, year){ const base=score(key), step=(hash("d|"+key)-0.45)*6.5, noise=(hash("ny|"+key+"|"+year)-0.5)*5; return clamp(base-(2025-year)*step+noise); }
function serie(key, nivel){ let prev=null; return ANIOS[nivel].map(y=>{ const v=valYear(key,y); let sigPrev=null,prevY=null; if(prev){ const d=v-prev.v, thr=4+hash("sg|"+key+y)*4; sigPrev=Math.abs(d)>=thr; prevY=prev.y; } const p={y,v,prelim:y===PRELIM,sigPrev,prevY}; prev={y,v}; return p; }); }
function barMini(key, nivel, color){
  const pts=serie(key,nivel);
  return `<div class="ybars">`+pts.map(p=>`<div class="ybar-col"><div class="ybar-plot"><div class="ybar-fill ${p.prelim?'is-prelim':''}" style="height:${p.v}%;background:${color}"><span class="ybar-val">${p.v}</span></div></div><div class="ybar-yr">${p.y}${p.prelim?'*':''}</div></div>`).join("")+`</div>`;
}
function trendStat(pts, tiny){
  const last=pts[pts.length-1], prev=pts.length>1?pts[pts.length-2]:null;
  if(!prev) return `<span class="hist-trend${tiny?' tiny':''} st-eq-tx">—</span>`;
  const d=last.v-prev.v, sigF=last.sigPrev;
  return `<span class="hist-trend${tiny?' tiny':''}">${stat(`vs ${prev.y}${last.prelim?' *':''}`, d, sigF, false, tiny)}</span>`;
}
function buildHist(f){
  const nivel=f.nivel, DKEY=f.key+"|"+f.nivel;
  const cap=`<div class="hist-cap"><b>Puntaje por año, eje fijo 0–100.</b> La barra con borde discontinuo y asterisco (*) es el año preliminar. ${nivel==="4b"?"4° básico no aplica 2024 (no se muestra barra ese año)":"serie 2022–2025"}.</div>`;
  const inds=IND.map(i=>{
    const ip=serie(DKEY+"|"+i.id, nivel);
    const dims=i.dims.map((d,di)=>{ const dcol=dimColor(i.color,di,i.dims.length);
      const dp=serie(DKEY+"|"+i.id+"|"+d.id, nivel);
      const subs=d.subs.map((nm,k)=>{ const scol=subColor(dcol,k);
        const sp=serie(DKEY+"|"+i.id+"|"+d.id+"|s"+k, nivel);
        return `<div class="hist-sub"><div class="hist-sub-n"><span class="sw xs" style="background:${scol}"></span>${nm}${trendStat(sp,true)}</div>${barMini(DKEY+"|"+i.id+"|"+d.id+"|s"+k, nivel, scol)}</div>`; }).join("");
      return `<div class="hist-dim"><div class="hist-dim-h"><span class="sw sm" style="background:${dcol}"></span>${d.nombre}${trendStat(dp,true)}</div>${barMini(DKEY+"|"+i.id+"|"+d.id, nivel, dcol)}<div class="hist-subs">${subs}</div></div>`; }).join("");
    return `<section class="hist-ind" style="--ic:${i.color}"><div class="hist-ind-h"><span class="indp-dot" style="background:${i.color}"></span><span class="hist-ind-name">${i.nombre}</span>${trendStat(ip)}</div><div class="hist-main">${barMini(DKEY+"|"+i.id, nivel, i.color)}</div><div class="hist-dims">${dims}</div></section>`;
  }).join("");
  return `<div class="ficha-explain"><b>Vista histórica.</b> Puntaje por año de cada indicador, dimensión y subdimensión, en eje fijo 0–100.</div><div class="hist-wrap">${cap}${inds}</div>`;
}
function renderFicha(){
  const root=document.getElementById("screen-ficha"); if(!root) return;
  const f=app.ficha, DKEY=f.key+"|"+f.nivel, nivelLab=NIVELES.find(n=>n.id===f.nivel).label, gseN=gseCorto(f.gse);
  const indAnc=IND.map(i=>({ind:i, a:ancla(DKEY+"|"+i.id)}));
  const axes=IND.map(i=>({color:i.color}));
  const radarSvg=radar({ size:360, axes, series:[
    { points:indAnc.map(x=>x.a.gseRef), stroke:"#B7AC96", w:1.8, dashed:true, dot:3 },
    { points:indAnc.map(x=>x.a.v), stroke:"#0A3A5C", fill:"rgba(10,58,92,.07)", w:2.4, vertexByAxis:true, dot:6 },
  ]});
  const pos=["pos-top","pos-right","pos-bottom","pos-left"];
  const rcards=indAnc.map((x,k)=>{
    const gc=x.a.estado==="bajo"?C_BAJO:(x.a.estado==="sobre"?C_SOBRE:C_NEUTRO), gly=x.a.estado==="bajo"?"▼":(x.a.estado==="sobre"?"▲":"=");
    return `<div class="rcard ${pos[k]}">
      <div class="rcard-top"><span class="rcard-dot" style="background:${x.ind.color}"></span><div>
        <span class="rcard-name">${x.ind.corto}</span>
        <span class="rcard-vals"><b>${x.a.v}</b><span class="u">/100</span> <span class="rcard-gse">GSE ${x.a.gseRef}</span> <span class="rcard-dev" style="color:${gc}">${gly}${x.a.gd>0?'+':''}${x.a.gd}</span></span>
      </div></div>
      <div class="rcard-def">${x.ind.def}</div>
      <div class="rcard-alto"><b>Los establecimientos que puntúan alto:</b> ${x.ind.alto}</div>
    </div>`;
  }).join("");

  const panels=IND.map(i=>{
    const ia=ancla(DKEY+"|"+i.id);
    const dims=i.dims.map((d,di)=>{
      const da=ancla(DKEY+"|"+i.id+"|"+d.id), dcol=dimColor(i.color,di,i.dims.length);
      const subs=d.subs.map((nm,k)=>{
        const sa=ancla(DKEY+"|"+i.id+"|"+d.id+"|s"+k), scol=subColor(dcol,k);
        return `<div class="sub">
          <div class="sub-head"><span class="sw xs" style="background:${scol}"></span><span class="sub-name">${nm}</span><span class="sub-score">${sa.v}<span class="u">/100</span></span></div>
          <div class="sub-bar">${bar0100({value:sa.v, gseRef:sa.gseRef, color:scol, noGse:sa.noData, h:20})}</div>
          <div class="sub-anc">${stat("GSE", sa.gd, sa.gs, sa.noData, true)}${stat("Año", sa.yd, sa.ys, false, true)}</div>
        </div>`;
      }).join("");
      return `<div class="dimb">
        <div class="dim-head"><span class="sw sm" style="background:${dcol}"></span><span class="dim-name">${d.nombre}</span><span class="dim-score">${da.v}<span class="u">/100</span></span></div>
        <div class="dim-bar">${bar0100({value:da.v, gseRef:da.gseRef, color:dcol, noGse:da.noData, h:30})}</div>
        <div class="dim-anc">${stat("vs su GSE", da.gd, da.gs, da.noData)}${stat("vs año anterior", da.yd, da.ys, false)}</div>
        <div class="subs">${subs}</div>
      </div>`;
    }).join("");
    return `<section class="indp" style="--ic:${i.color}">
      <header class="indp-head"><span class="indp-dot" style="background:${i.color}"></span>
        <div class="indp-tt"><div class="indp-name">${i.nombre}</div><div class="indp-sub">${i.dims.length} dimensiones · ${i.dims.reduce((a,d)=>a+d.subs.length,0)} subdimensiones</div></div>
        <div class="indp-score">${ia.v}<span class="u">/100</span></div></header>
      <div class="indp-anc">${stat("vs su GSE", ia.gd, ia.gs, ia.noData)}${stat("vs año anterior", ia.yd, ia.ys, false)}<span class="indp-gseref">ref. GSE ${gseN}: <b>${ia.gseRef}</b> puntos</span></div>
      <div class="indp-body">${dims}</div>
    </section>`;
  }).join("");

  const isHist = f.view==="historica";
  const L=levelsOf(f.key);
  const fnivelSeg=NIVELES.map(n=>{ const off=(n.id==="4b"&&!L.b4)||(n.id==="2m"&&!L.m2); return `<button class="lvl-b ${f.nivel===n.id?'on':''} ${off?'is-off':''}" data-fnivel="${n.id}" ${off?'disabled title="Sin datos en este nivel"':''}>${n.label}</button>`; }).join("");
  const bar = `
    <div class="ficha-bar">
      <div class="ficha-id">
        <div class="ficha-name">${f.nombre.replace(/\s*\(RBD[^)]*\)\s*$/,"")}<span class="ficha-rbd">RBD ${f.rbd}</span></div>
        <div class="ficha-meta">${f.comuna} · ${f.terr} · GSE ${gseN} · ${nivelLab} · 2025 (preliminar)</div>
      </div>
      <div class="ficha-tools">
        <div class="nivelsel"><span class="nivelsel-lab">Vista</span><div class="seg-lvl big"><button class="lvl-b ${!isHist?'on':''}" data-fview="actual">Vista actual</button><button class="lvl-b ${isHist?'on':''}" data-fview="historica">Vista histórica</button></div></div>
        <div class="nivelsel"><span class="nivelsel-lab">Nivel</span><div class="seg-lvl big">${fnivelSeg}</div></div>
      </div>
    </div>
    <div class="picker-bar">
      <span class="picker-lab">Establecimiento</span>
      <div class="picker-ctl estab-search-wrap">
        <input id="estab-search" class="estab-search" placeholder="Buscar por nombre o RBD…" autocomplete="off" />
        <div id="estab-results" class="estab-results"></div>
      </div>
    </div>`;
  const actual = `
    <div class="ficha-explain"><b>Una sola pantalla, todo desplegado.</b> Indicador (radar), dimensión y subdimensión (barras 0–100) con el puntaje del establecimiento, su <b>referencia GSE</b> sobre la barra y su <b>variación interanual</b>. La significancia se lee por icono + texto (▼ bajo · = sin diferencia · ▲ sobre), nunca solo por color.</div>
    ${legendStd()}
    <div class="ficha-radar">
      <div class="fr-head">Mirada integral · 4 indicadores</div>
      <div class="rquad"><div class="rquad-svg">${radarSvg}</div>${rcards}</div>
      <p class="fr-note">El radar es solo para los <b>4 indicadores</b>. Dimensiones y subdimensiones (2–3 variables) usan barras 0–100, en tonos coherentes con el color de su indicador.</p>
    </div>
    <div class="ficha-panels">${panels}</div>`;
  root.innerHTML = bar + `<div class="ficha-card">` + (isHist ? buildHist(f) : actual) + `</div>`;
}

/* ============================================================
   PANTALLA 3 — Comparación entre territorios (rail GSE + tabla)
   ============================================================ */
function repartoComp(terrId, gse, indId){
  const kb=hash("rb|"+terrId+gse+indId), ka=hash("ra|"+terrId+gse+indId), N=24+Math.floor(hash("n|"+terrId+gse)*60);
  let bajo=Math.round(N*(0.14+kb*0.34)), sobre=Math.round(N*(0.10+ka*0.30));
  if(bajo+sobre>N){const ex=bajo+sobre-N;bajo-=Math.ceil(ex/2);sobre-=Math.floor(ex/2);}
  return { bajo:Math.max(0,bajo), neutro:Math.max(0,N-bajo-sobre), sobre:Math.max(0,sobre), N };
}
function renderComparar(){
  const root=document.getElementById("screen-comparar"); if(!root) return;
  const chips=TERR.map(t=>`<div class="cmp-chip"><span class="cmp-ct"><span class="cmp-cn">${t.nombre}</span><span class="cmp-cm">${t.meta}</span></span><button class="cmp-x">✕</button></div>`).join("");
  const nivelSeg=NIVELES.map(n=>`<button class="lvl-b ${app.cmpNivel===n.id?'on':''}" data-cmpnivel="${n.id}">${n.label}</button>`).join("");
  // segmentador horizontal por GSE
  const gseFilter=GSE.map(g=>`<button class="gfb ${app.cmpGseVis.has(g.cod)?'on':''}" data-railgse="${g.cod}"><span class="gf-check">${app.cmpGseVis.has(g.cod)?'✓':''}</span>${g.corto}</button>`).join("");
  // tabla por GSE
  const visGse=GSE.filter(g=>app.cmpGseVis.has(g.cod));
  const sections=visGse.map(g=>`
    <section class="gse-sec" id="gsec-${g.cod}">
      <div class="gse-sec-h"><span class="gse-sec-name">${g.corto}</span><span class="gse-sec-sub">Grupo socioeconómico</span></div>
      <table class="cmp-table">
        <thead><tr><th class="th-terr">Territorio</th>${IND.map(i=>`<th><span class="th-sw" style="background:${i.color}"></span>${i.corto}</th>`).join("")}</tr></thead>
        <tbody>
          ${TERR.map(t=>`<tr>
            <td class="td-terr"><span class="td-tn">${t.nombre}</span></td>
            ${IND.map(i=>`<td>${stacked100(repartoComp(t.id,g.cod,i.id), true)}</td>`).join("")}
          </tr>`).join("")}
        </tbody>
      </table>
    </section>`).join("");

  root.innerHTML=`
    <div class="cmp-chrome">
      <div class="cmp-bar">
        <div class="cmp-bar-tt"><span class="cmp-eyebrow">SLEP Costa Central · Comparador IDPS</span><h3 class="cmp-title"><b>Comparación entre territorios</b> <span class="cmp-title-sub">por nivel y GSE</span></h3></div>
        <div class="pan-nivel"><div class="nivelsel"><span class="nivelsel-lab">Nivel</span><div class="seg-lvl big">${nivelSeg}</div></div></div>
      </div>
    </div>
    <div class="cmp-noagg"><b>No se promedia ni se agrega.</b> Cada celda reparte el <b>100% de los establecimientos</b> del territorio (en ese GSE e indicador) en tres estados vs su propio GSE. Es <b>% (n)</b> de establecimientos, no una media de puntajes.</div>
    <div class="cmp-controls"><div class="cmp-cg"><span class="cmp-cl">Territorios a comparar · ${TERR.length} de 4</span><div class="cmp-chips">${chips}${TERR.length<4?'<button class="cmp-add">+ agregar territorio</button>':''}</div></div></div>
    <div class="gse-filter-wrap">
      <span class="cmp-cl">Segmentar por GSE</span>
      <span class="gse-filter-note">Muestra u oculta cada grupo socioeconómico; baja para verlos todos.</span>
      <div class="gse-filter">${gseFilter}</div>
    </div>
    ${legendStd()}
    <div class="cmp2-data">${sections || '<div class="cmp2-empty">Selecciona al menos un grupo socioeconómico (GSE) en el segmentador de arriba.</div>'}</div>`;
}

/* ============================================================
   Render + eventos
   ============================================================ */
function render(){ if(app.screen==="territorio") renderTerritorio(); else if(app.screen==="ficha") renderFicha(); else renderComparar(); }

document.addEventListener("click", e=>{
  const nav=e.target.closest(".nav-item"); if(nav){ show(nav.dataset.screen); return; }
  const back=e.target.closest("[data-back]"); if(back){ show(back.dataset.back); return; }
  const card=e.target.closest(".gcard[data-estab]"); if(card){
    const k=card.dataset.estab;
    app.ficha={ key:k, nombre:estName(card.dataset.nombre, card.dataset.rbd), comuna:card.dataset.comuna, rbd:card.dataset.rbd, gse:+card.dataset.gse, nivel:defaultNivel(k), terr:TERR.find(t=>t.id===app.panTerr).nombre, view:"actual" };
    show("ficha"); return;
  }
  const pg=e.target.closest("[data-pangse]"); if(pg){ const c=+pg.dataset.pangse; app.panGseVis.has(c)?app.panGseVis.delete(c):app.panGseVis.add(c); renderTerritorio(); return; }
  const pn=e.target.closest("[data-pannivel]"); if(pn){ app.panNivel=pn.dataset.pannivel; renderTerritorio(); return; }
  const cn=e.target.closest("[data-cmpnivel]"); if(cn){ app.cmpNivel=cn.dataset.cmpnivel; renderComparar(); return; }
  const rg=e.target.closest("[data-railgse]"); if(rg){ const c=+rg.dataset.railgse; app.cmpGseVis.has(c)?app.cmpGseVis.delete(c):app.cmpGseVis.add(c); renderComparar(); return; }
  const fv=e.target.closest("[data-fview]"); if(fv){ app.ficha.view=fv.dataset.fview; renderFicha(); return; }
  const fn=e.target.closest("[data-fnivel]"); if(fn){ app.ficha.nivel=fn.dataset.fnivel; renderFicha(); return; }
  const eo=e.target.closest(".estab-opt"); if(eo){ const p=SEARCH_POOL[+eo.dataset.pidx]; app.ficha={ key:p.key, nombre:estName(p.nombre,p.rbd), comuna:p.comuna, rbd:p.rbd, terr:p.terr, gse:p.gse, nivel:defaultNivel(p.key), view:app.ficha.view }; renderFicha(); return; }
  if(!e.target.closest(".estab-search-wrap")){ const r=document.getElementById("estab-results"); if(r){ r.classList.remove("open"); } }
});
document.addEventListener("input", e=>{ if(e.target.id==="estab-search"){ renderEstabResults(e.target.value); } });
document.addEventListener("change", e=>{
  if(e.target.id==="pan-terr"){ app.panTerr=e.target.value; renderTerritorio(); }
});

function boot(){ render(); document.querySelectorAll(".nav-item").forEach(n=>n.classList.toggle("on", n.dataset.screen===app.screen)); }
if (document.readyState!=="loading") boot(); else document.addEventListener("DOMContentLoaded", boot);
window.IDPSDEMO = { IND, GSE };
})();
