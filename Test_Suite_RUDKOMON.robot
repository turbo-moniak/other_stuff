*** Settings ***
Library           Collections
Library           Process
Library           String
Library           statusCheck.py

*** Variables ***
${Tab1}           ${EMPTY}

*** Test Cases ***
TC 1.0
    [Setup]    Variable Should Exist    ${Tab1}
    ${X}=    Set Variable    21
    ${Z}=    Set Variable    ${X}+100
    ${len}=    Get Tab1 Length    ${Tab1}
    Run Keyword If    ${len} >= 1    Remove Value From Tab
    ...    ELSE    Add Value To Tab    ${X}    ${Z}
    ${len}=    Get Tab1 Length    ${Tab1}
    Run Keyword If    ${len}==0    Fail    msg=Tab1 is empty
    ...    ELSE    Log To Console    \n@Tab1 filled with data
    Current Time

TC 1.1
    [Setup]    Should Be Equal    ${PREV TEST STATUS}    PASS    FAIL
    ${len}=    Get Length    ${Tab1}
    Run Keyword If    ${len}==0    Log To Console    \nTab1 is EMPTY
    @{status}=    Create List
    : FOR    ${i}    IN    @{Tab1}
    \    ${isString}=    Run Keyword And Return Status    Should Be String    ${i}
    \    ${counter}=    Check Status    ${isString}    ${len}
    Log To Console    \nThere are ${counter} strings in @Tab1\n
    ${execution}=    Set Variable    Execution
    : FOR    ${i}    IN RANGE    ${len}
    \    ${element}=    Set Variable    ${Tab1[${i}]}
    \    ${howMany}=    Count Values In List    ${Tab1}    ${element}
    \    Run Keyword If    ${howMany}>1    Log To Console    \nString ${element} appear more than once in Tab1
    \    ${isIn}=    Evaluate    $execution in $element
    \    Run Keyword If    ${isIn}!=True    Log To Console    \nExecution is not in string

TC 1.2
    [Setup]    Should Be Equal    ${PREV TEST STATUS}    PASS
    ${element}=    Get From List    ${Tab1}    -1
    ${number}=    Set Variable    120
    Set Global Variable    ${number}
    ${expression}=    Evaluate    $number in $element
    Create Statement    ${expression}

TC 1.3
    [Setup]    Variable Should Exist    ${Tab1}
    ${len}=    Get Length    ${Tab1}
    ${STR}=    Set Variable    ${Tab1[0]}:${Tab1[${len-1}]}
    Log To Console    \nTest result: ${STR}
    [Teardown]    Run Keyword If    "${TEST STATUS}"=="FAIL"    Fail    "TC 1.3 failed"

*** Keywords ***
Current Time
    @{time}=    Get Time    hour min sec
    Reverse List    ${time}
    ${time}=    Catenate    SEPARATOR=-    @{time}
    [Return]    ${time}

Add Value To Tab
    [Arguments]    ${X}    ${Z}
    : FOR    ${i}    IN RANGE    ${X}    ${Z}
    \    ${str}=    Convert To String    ${i}
    \    ${string}=    Set Variable    Execution.${str}.txt
    \    Append To List    ${Tab1}    ${string}

Remove Value From Tab
    ${len}=    Get Tab1 Length    ${Tab1}
    : FOR    ${i}    IN RANGE    0    ${len}
    \    Remove From List    ${Tab1}    0

Get Tab1 Length
    [Arguments]    ${Tab1}
    ${len}=    Get Length    ${Tab1}
    [Return]    ${len}

Create Statement
    [Arguments]    ${expression}
    ${time_string}=    Current Time
    Run Keyword If    ${expression}==False    Fail    msg=${time_string} - Tab1 nie zawiera numeru ${number}
    ...    ELSE    Log To Console    \n: ${time_string} - Tab1 zawiera numer ${number}
