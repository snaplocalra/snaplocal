class PasswordValidationRule {
  final String ruleDescription;
  final bool Function(String password) isRuleValid;

  PasswordValidationRule({
    required this.ruleDescription,
    required this.isRuleValid,
  });
}
