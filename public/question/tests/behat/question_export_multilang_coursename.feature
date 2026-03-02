@core @core_question
Feature: In question exports, multilingual course names should be supported
  When exporting a question as XML in a course which has a different name in different languages
  As a teacher
  I want the filename to contain only the coursename in my language

  Background:
    Given the following "users" exist:
      | username |
      | teacher  |
    And the following "courses" exist:
      | fullname | shortname                                                                                          | category |
      | Course 1 | <span lang="en" class="multilang">Title EN</span><span lang="de" class="multilang">Title DE</span> | 0        |
    And the following "course enrolments" exist:
      | user    | course                                                                                             | role           |
      | teacher | <span lang="en" class="multilang">Title EN</span><span lang="de" class="multilang">Title DE</span> | editingteacher |
    And the following "question categories" exist:
      | contextlevel | reference                                                                                          | name           |
      | Course       | <span lang="en" class="multilang">Title EN</span><span lang="de" class="multilang">Title DE</span> | Test questions |
    And the following "questions" exist:
      | questioncategory | qtype     | name           | template |
      | Test questions   | truefalse | true-false-001 | true     |
    And the "multilang" filter is "on"
    And the "multilang" filter applies to "content and headings"

  Scenario: Export a question in course with multilang name
    When I am on the "Course 1" "core_question > course question export" page logged in as teacher
    And I set the field "id_format_xml" to "1"
    And I press "Export questions to file"
    Then following "click here" should download a file whose default name matches "/^questions-Title EN-Test questions-[0-9-]+.xml$/"
    # If the download step is the last in the scenario then we can sometimes run
    # into the situation where the download page causes a http redirect but behat
    # has already conducted its reset (generating an error). By putting a logout
    # step we avoid behat doing the reset until we are off that page.
    And I log out
