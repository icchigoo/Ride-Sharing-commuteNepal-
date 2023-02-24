Feature: OTP Verification
    Scenario: The number field is empty
        Given I am on the login page
        When I enter a valid phone number
        And I click on the next button
        Then I should get verification code
