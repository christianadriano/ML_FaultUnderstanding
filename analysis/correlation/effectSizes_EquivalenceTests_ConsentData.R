"
Test of Equivalence between two means.
This is done after we fail to reject a null-hypothesis.

TODO:
- Compute correlation matrix
- For the non-significant correlations, run TOST (assuming effect less than small)


"
install.packages("TOSTER")
library(TOSTER)

"Load data with treatment field (isBugCovering) and ground truth (answer correct)"
source("C://Users//Christian//Documents//GitHub//CausalModel_FaultUnderstanding//data_loaders//load_consent_create_indexes_E2.R")

