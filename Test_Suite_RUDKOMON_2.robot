*** Settings ***
Library           Process
Library           OperatingSystem
Library           String
Library           Collections

*** Variables ***
${file}           memory.txt

*** Test Cases ***
TC 1.0 wypisać użytą i wolną pamięć RAM
    ${test}=    Run    free -m > ${file}
    ${content}=    Get File    ${file}
    ${line_0}=    Get Line    ${content}    0
    ${line_1}=    Get Line    ${content}    1
    @{list_0}=    Split String    ${line_0}
    @{list_1}=    Split String    ${line_1}
    ${used}=    Get Index From List    ${list_0}    used
    ${free}=    Get Index From List    ${list_0}    free
    ${used_val}=    Get From List    ${list_1}    ${used + 1}
    ${free_Val}=    Get From List    ${list_1}    ${free + 1}
    Log To Console    \n free -m output:\n ${content}
    Log To Console    \nUSED: ${used_val}\n\nFREE: ${free_val}
