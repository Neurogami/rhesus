Feature: <%= tuple_to_test %> setting

  Scenario: Set timeout option
    Given I open "<%= tuple_to_test %> Something or Other"
    Given the frame "<%= tuple_to_test %>" is the container
    When I change the spinner named "popup_interval" to 20
    Then the spinner named "popup_interval" should be 20
    Then the spinner named "popup_interval" should not be 12

