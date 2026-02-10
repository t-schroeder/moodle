@mod @mod_assign
Feature: In assignment, multilingual course names should be supported
  When downloading submissions in bulk
  As a teacher
  I want the filename to contain only the coursename in my language

  Background:
    Given the following "courses" exist:
      | fullname                                                                                           | shortname                                                                                          | category |
      | <span lang="en" class="multilang">Title EN</span><span lang="de" class="multilang">Title DE</span> | <span lang="en" class="multilang">Title EN</span><span lang="de" class="multilang">Title DE</span> | 0        |
    And the "multilang" filter is "on"
    And the "multilang" filter applies to "content and headings"
    And the following "users" exist:
      | username  | firstname  | lastname  | email                 |
      | teacher1  | Teacher    | 1         | teacher1@example.com  |
      | student1  | Student    | 1         | student1@example.com  |
    And the following "course enrolments" exist:
      | user      | course                                                                                             | role            |
      | teacher1  | <span lang="en" class="multilang">Title EN</span><span lang="de" class="multilang">Title DE</span> | editingteacher  |
      | student1  | <span lang="en" class="multilang">Title EN</span><span lang="de" class="multilang">Title DE</span> | student         |

  @javascript
  Scenario: When downloading all submissions the filename should only contain the coursename in my selected language.
    Given the following "activity" exists:
      | activity                            | assign                                                                                             |
      | course                              | <span lang="en" class="multilang">Title EN</span><span lang="de" class="multilang">Title DE</span> |
      | name                                | Test assignment name                                                                               |
      | assignsubmission_onlinetext_enabled | 1                                                                                                  |
    And the following "mod_assign > submissions" exist:
      | assign                | user      | onlinetext                       |
      | Test assignment name  | student1  | I'm the student first submission |
    And I am on the "Test assignment name" Activity page logged in as teacher1
    And I change window size to "large"
    When I navigate to "Submissions" in current page administration
    And I click on "Actions" "button"
    Then the "Download all submissions" item should exist in the "Actions" action menu
    And following "Download all submissions" should download a file whose default name matches "/^Title EN-Test assignment name-[0-9]+.zip$/"
