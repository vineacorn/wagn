Feature: Update Includer cards
  In order for Notifications to be more user friendly
  Users should be notified when transcluded plus cards of a card they are watching change.

  Background:
    Given I log in as Joe User
    And I create Book card "Ulysses"
    And Joe Camel is watching "Ulysses"
    And Joe Admin is watching "Book"
  
  Scenario: Watcher should be notified of updates to transcluded plus card
    When I create card "Ulysses+author" with content "James Joyce"
    Then Joe Camel should be notified that "Joe User updated \"Ulysses\""   
    #And He should see "added Ulysses+author" in the email  -- FIXME need multiline matching
    And Joe Admin should be notified that "Joe User updated \"Ulysses\""
    When Joe Admin edits "Ulysses+author" setting content to "Jim"
    Then Joe Camel should be notified that "Joe Admin updated \"Ulysses\""
    #And Joe Admin should be notified that "Joe User updated \"Ulysses\""
    
  Scenario: Should not notify of transcluded but not plussed card
    When I create card "illustrator" with content "Picasso"
    Then No notification should be sent                                     
    
  Scenario: Should not notify of plussed but not transcluded card
    When I create card "Ulysses+random" with content "boo"
    Then No notification should be sent

  Scenario: Templated cards should only send one email when added or updated
    When I create Book card "Bros Krmzv" with plusses:
      |author|
      |Dostoyevsky|
    Then Joe Admin should be notified that "Joe User added \"Bros Krmzv\""    
    When I edit "Bros Krmzv" with plusses:
      |author|illustrator|
      |Rumi|Monet|
    Then Joe Admin should be notified that "Joe User updated \"Bros Krmzv\""    

  Scenario: Watching a plus card on multiedit; and watching both plus card and including card on multiedit
    Given I create Cardtype card "Froot"
    And I create card "Froot+*type+*content" with content "{{+color}} {{+flavor}}"
    And I create Froot card "Banana" with plusses:
      |color|flavor|
      |yellow|sweet|
    And Joe Camel is watching "Banana+color"
    When I edit "Banana" with plusses:
      |color|flavor|
      |spotted|mushy|
    Then Joe Camel should be notified that "Joe User edited \"Banana\+color\""    
    When Joe Camel is watching "Banana"
    And I edit "Banana" with plusses:
      |color|flavor|
      |spotted|mushy|
    Then Joe Camel should be notified that "Joe User updated \"Banana\""
    
  Scenario: Watching a plus card & including card on regular edit
    When I create card "Ulysses+author" with content "Joyce"
    Then Joe Camel should be notified that "Joe User updated \"Ulysses\""
    When Joe Camel is watching "Ulysses+author"
    And I edit "Ulysses+author" setting content to "Jim"
    Then Joe Camel should be notified that "Joe User updated \"Ulysses\""
      
    
