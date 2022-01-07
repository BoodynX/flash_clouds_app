String? addValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Card can\'t be empty';
  }

  if (value.length > 500) {
    return 'Card max length is 500 characters';
  }

  return null;
}
