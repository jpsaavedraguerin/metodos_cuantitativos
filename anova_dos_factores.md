## Análisis factorial de varianza - ANOVA de dos factores

ANOVA de dos factores es una extensión de ANOVA de un factor. En el de un factor se etudia el efecto de un factor sobre la variale de decición, mientras que en el de dos factores, el efecto de dos favtores en la variable de decisión es simultáneamente estudiado. 

Un analisis de dos factores se diseña con el objetivo de comparar el efecto de multiples nivels de dos factores simultaneamentes en la variable de decisión. ANOVA de dos factores se realiza en dos situaciones: primero, cuando hay una observación por celda y, segundo, cuando hay mas de una observación por celda. En este ultimo caso, es necesario que las celdas tenga el mismo numero de observaciones. Usar ANOVA de dos factores con n observaciones permite verificar si hay interacción entre los dos factores. 

Ventajas:   
- permite estudiar el efecto de dos factores en la variable de decisión y el efecto de la interacción entre ellas.   
- Permite reducir la varianza del error ya que hay dos fuentes de variación posibles, y por lo tanto hace el diseño más eficiente.  

**Ventajas ANOVA de dos factores sobre ANOVA de un factor:**

- Permite estudiar dos factores al mismo tiempo. 
- Debido a que la variación puede explicarse por dos posibles causas, reduce el error de variabilidad. Es más eficiente. 
- Se puede probar la independencia de los factores siempre que haya mas de una observación por celda (el numero de observaciones por celda debe ser el mismo). En ANOVA de un factor, se debe tener un número dispar de observaciones en cada grupo. 
- Además de reducir el error de variabilidad, ANOVA de dos factores reduce el cálculo, ya que incluye varios ANOVA de un factor. 


## Principios 

Al diseñar experimentos, y con el objetivo de minimizar el error de varianza, se deben considerar tres principios: aletoriedad, replicación y control local. Estos permiten una mejor posición al concluir si la variación de la variable de decisión es debida un nivel identificable de un factor en particular.   

- **Aleatoriedad:** Las muestras de cada grupo son seleccionadas de forma aleatoria. Esto permite evita que las muestras estén sesgadas y que cada grupo sea lo más homogeneo posible.   

- **Replicación:** Estudiar el efecto de dos factores en más de un objeto de estudio. Permite estudiar la significancia de la interación entre los dos factores. Se hace imposible estudiar la interacción si sólo existe una observación en cada celda.  

- **Control local de variables:** Hacer los gruipos lo más homogeneos posibles de tal forma que la variación debida a uno o más causas posibles pueda ser aislada del error experimental. La aplicación del control local permite ayudarnos a reducir el error de variación y hacer el diseño más eficiente. Por ejemplo, si al estudiar la satisfacción en el empleo se realizara ANOVA I, y agruparamos a los empleados por edad, podríamos tener mayor variabilidad en los resultados debida por ejemplo a la infliuencia del género en la satisfacción. Por lo tanto, al considerar el género, haciendo los grupos mas hómogeneos, se disminuye esa variabilidad.   

# Terminología 

- **Factores:** Variables independientes a ser estudiadas. El efecto de dos factores es estudiado en cierta variable de decisión. Cada uno de los factores tiene dos o más niveles. Los grados de libertad (gl)se calculan de la siguiente forma:  

$$Sea\ N_{s}=número\ de\ niveles\ del\ factor\ s$$
 
$$gl_{s}=N_{s} - 1$$

- **Grupos de tratamiento:** Corresponde a todas las posibles combinaciones de niveles entre el factor A y factor B. 

$$Sea\ A_{i}\ el\ i-ésimo\ nivel\ del\ factor\ A,\ i=\{1,...,p\}$$

$$Sea\ B_{j}\ el\ j-ésimo\ nivel\ del\ factor\ B,\ j=\{1,...,q\}$$

$$El\ número\ de\ grupos\ de\ tratamientos\ distintos\ es:\ p*q$$

- **Efecto principal:** Corresponde al efecto de una variable independiente (o factor) en la variable independiente a partir de todos los niveles de la otra variable. Se ignora en este caso el efecto de la interacción. Sólo se usan las filas o las columnas, pero no ambas. Este análisis es similar al análisis de varianza de ANOVA de un factor. Cada una de las varianzas calculadas para analizar el efecto principal (filas y columnas) es como una "varianza entre". Los grados de libertad para el efecto principal se calculan de la siguiente forma: 

$$gl_{A}=(p-1)\ \ gl_{B}=(q-1)$$

- **Efecto de la interacción:** Corresponde al efecto conjunto de los dos factores sobre una variable dependiente. También puede ser definido como el efecto que un factor tiene sobre el otro factor. Los grados de libertad de la interacción es igual al producto de los grados de libertad de la interacción: 

$$gl_{(A \wedge B)} = gl_{A}*gl_{B} = (p-1)*(q-1)$$

- **Variación dentro grupos:** La variación dentro del grupo es la suma de cuadrados dentro de cada grupo de tratamiento. En el ANOVA de dos factores, cada grupo de tratamiento debe tener el mismo tamaño de muestra. La variancia dentro es igual a la variancia dentro deividida por sus grados de libertad. La varianza dentro del grupo es también llamada error. La variación dentro del grupo es frecuentemente llamada SSE.

# Modelo ANOVA de dos factores. 

## Condiciones del modelo: 
1. El tamaño de muestra en cada celda debe ser el mismo. 

## Supuestos del modelo

1. Las poblaciones desde donde se toman las muestras se distribuyen normalmente. 
2. Las muestras son independientes. 
3. La varianza de las poblaciones debe ser igual (homocedasticidad)
4. El tamaño de muestra debe ser igual en cada celda. 

## Formalización del modelo



# Ejemplo

# Referencias

- [ANOVA in R: A step-by-step guide](https://www.scribbr.com/statistics/anova-in-r/)
- J.P Verma, *Data Analysis in Management With SPSS Software*, DOI:10.1007/978-81-322-0786-3_8, (C) Springer India 2013
- [aov documentation](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/aov)