## fonction pour convertir temp�ratures moyennes journali�res en ddj
convertmoyjdj <- function(Tu, Tl, Tmax, Tmin)
{
	provi <- (Tmax + Tmin)/2
	if (provi >= Tl)
		provi - Tl
	else
		0
}