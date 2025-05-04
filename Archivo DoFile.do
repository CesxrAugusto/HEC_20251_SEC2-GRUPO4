
clear all

global Bases "C:\Users\cespi\OneDrive\Escritorio\Universidad\Sexto Semestre\Historia Economica de Colombia\Bases"

import delimited "${Bases}/MEN_ESTADISTICAS_EN_EDUCACION_EN_PREESCOLAR__B_SICA_Y_MEDIA_POR_MUNICIPIO_20240818.csv"

// Filtrado y Organización de los Datos
rename año ano

rename código_municipio codmpio

destring ano, replace ignore(",")

merge 1:1 codmpio ano using "${Bases}/General Characteristics 2022.dta"

drop _merge

merge 1:1 codmpio ano using "${Bases}/Conflict and Violence 2022.dta"

drop _merge

merge 1:1 codmpio ano using "${Bases}/Salud y Servicios Panel.dta"

drop _merge

merge 1:1 codmpio ano using "${Bases}/Education Panel 2023.dta"

drop _merge

replace departamento = depto if missing(departamento)

gen keep_obs1 = inlist(municipio, ///
"Yondó", "Puerto Nare", "Puerto Berrío", "Puerto Triunfo", ///
"Cantagallo", "San Pablo", "Santa Rosa del Sur")
gen keep_obs2 = inlist(municipio, "Simití", "Arenal", "Barranco de Loba", ///
"San Martín de Loba", "El Peñón", "Hatillo de Loba", "Montrecristo")

gen keep_obs3 = inlist(municipio,"Morales", "Norosí", ///
"Regidor", "Río Viejo", "Tiquisio", "Puerto Boyacá")

gen keep_obs4 = inlist(municipio, "La Dorada", "Aguachica", "Gamarra", ///
"González", "La Gloria", "Río de Oro", "San Alberto")

gen keep_obs5 = inlist(municipio,"San Martín", "Tamalameque", ///
"Puerto Salgar", "Barrancabermeja", "Betulia", "El Carmen de Chucurí", "Puerto Wilches")

gen keep_obs6 = inlist(municipio, "Bajo Río Negro", "Sabana de Torres", "San Vicente de Chucurí", "Bajo Simacota")

gen keep_obs7 = inlist(municipio, "Puerto Parra", "Cimitarra", "Landázuri", "Santa Helena del Opón", "Bolívar")

keep if inlist(departamento, "Antioquia", "Bolívar", "Boyacá", "Caldas", "Cundinamarca", "Santander")

gen tratamiento = 0

replace tratamiento = 1 if keep_obs1 == 1
replace tratamiento = 1 if keep_obs2 == 1
replace tratamiento = 1 if keep_obs3 == 1
replace tratamiento = 1 if keep_obs4 == 1
replace tratamiento = 1 if keep_obs5 == 1
replace tratamiento = 1 if keep_obs6 == 1
replace tratamiento = 1 if keep_obs7 == 1

gen post = (ano > 2006)
gen did = tratamiento * post
gen ln_pobl_tot = ln(pobl_tot)

keep if ano <= 2010
keep if ano >2002

// Ejecución del Modelo
xtreg pib_percapita did tratamiento post c.H_coca##c.ano c.ln_pobl_tot##c.ano terrorismot 
asdoc xtreg pib_percapita did tratamiento post c.H_coca##c.ano c.ln_pobl_tot##c.ano terrorismot, replace

// Búsqueda del Promedio de PIB_perCapita para los años evaluados en el Magdalena Medio = 7.349.012
summarize ano pib_percapita if tratamiento == 1


