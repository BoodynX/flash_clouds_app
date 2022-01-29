enum Familiarity { none, medium, perfect }

Familiarity familiarityByVal(String? submittedValue) {
  if (submittedValue == null) {
    return Familiarity.none;
  }

  return Familiarity.values.firstWhere(
      (val) => val.toString() == 'Familiarity.' + submittedValue,
      orElse: () => Familiarity.none);
}
