enum Familiarity { none, medium, perfect }

// Translate string number of familiarity level in to Familiarity enum value.
// IUseful when retrieving familiarity level from storage.
Familiarity familiarityByVal(String? submittedValue) {
  if (submittedValue == null) {
    return Familiarity.none;
  }

  return Familiarity.values.firstWhere(
      (val) => val.toString() == submittedValue,
      orElse: () => Familiarity.none);
}
