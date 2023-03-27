import Vapor
import RegexBuilder

extension ValidatorResults {
    struct StrongPassword {
        let isStrongPassword: Bool
    }
}

extension ValidatorResults.StrongPassword: ValidatorResult {
    var isFailure: Bool {
        !isStrongPassword
    }

    var successDescription: String? {
        "is a strong password"
    }
    
    var failureDescription: String? {
        "is not a strong enough password"
    }
}

extension Validator where T == String {
    private static var strongPasswordRegex = Regex {
        Anchor.startOfSubject
        Lookahead {
            Regex {
                OneOrMore(.any)
                "A"..."Z"
            }
        }
        Lookahead {
            Regex {
                ZeroOrMore(.any)
                One(.digit)
            }
        }
        Lookahead {
            Regex {
                ZeroOrMore(.any)
                One(.anyOf("@$!%*#?&"))
            }
        }
        Repeat(8...) {
            CharacterClass(
                .anyOf("@$!%*#?&"),
                ("A"..."Z"),
                ("a"..."z"),
                .digit
            )
        }
        Anchor.endOfSubject
    }

    public static var strongPassword: Validator<T> {
        .init { data -> ValidatorResult in
            guard data.contains(strongPasswordRegex) else {
                return ValidatorResults.StrongPassword(isStrongPassword: false)
            }
            return ValidatorResults.StrongPassword(isStrongPassword: true)
        }
    }
}
