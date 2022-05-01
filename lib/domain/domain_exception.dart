/// Represents an error in the business rules of the domain.
class DomainError extends Error {
  final String message;

  DomainError(this.message);
}
