# RIA-CadreEthique
Codes des exemples de l'article "Cadre déclaratif modulaire d'évaluation d'actions selon différents principes éthiques", pour la Revue d'Intelligence Artificielle


Pour executer un exemple : 
 > python ethicalFullProcess.py <fichier .conf>

Cela écrit les résultats dans les fichiers spécifiés dans le fichier .conf

Pour l'exemple de dilemme médical : 
 > python ethicalFullProcess.py med.conf
La trace évènementiel est écrite dans traceMed.lp, la trace causale dans traceMedC.lp et les résultats d'admissibilité dans resultMed.lp
Note : par défaut, les poids de la valeur "respectForTheDead" sont à 0,0. Il est possible de les modifier dans medEthSpec.lp pour obtenir les résultats à deux valeurs.

Pour l'exemple sur le dilemme du trolley : 
 > python ethicalFullProcess.py trolley.conf
La trace évènementiel est écrite dans traceTroll.lp, la trace causale dans traceTrollC.lp et les résultats d'admissibilité dans resultTroll.lp


