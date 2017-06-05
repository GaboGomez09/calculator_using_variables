#ifndef parser
#define parser
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* subtract_string(char* string1, char* string2)
{
  int counter, counter2, match, start, found_string = 0;
  /*
      The first part of this function checks if string2 is contained
      in string1, it does this by counting how many characters
      match after its first encounter. It only subtracts the
      first instance found.
  */
  for (counter = 0; counter < strlen(string1); counter++)
  {
    counter2 = 0;
    /*
        The first if assures that it has found matching character
        and that it won't give a null pointer error.
    */
    if ((string1)[counter] == string2[counter2]
    && strlen(string1)-counter >= strlen(string2))
    {
      match = 0;
      for (counter2 = 0; counter2 < strlen(string2); counter2++)
      {
        if ((string1)[counter+counter2] == string2[counter2])
        {
          match++;
        }
      }
      /*
        After finishing iterating the next step is to know if it could
        find string2 inside of string1, this is known if match is equal
        to the length of string2.
      */
      if (match == strlen(string2)) {
        //It saves the position where it encountered the first character.
        start = counter;
        //Flag to notify that the string has been found.
        found_string = 1;
      }
      //In the case that this is not true the function does nothing and
      //it keeps searching.
    }
  }
  /*
      In the case that it string2 is a substring of string1 it will
      iterate through string1 copying all the characters to a new char*
      except the substring.
  */
  if (found_string)
  {
    counter2 = 0;
    char* subtracted_string = (char*)malloc(strlen(string1)-strlen(string2)+1);
    for (counter = 0; counter < strlen(string1); counter++)
    {
      if (counter == start)
      {
        counter += strlen(string2);
      }
      subtracted_string[counter2] = string1[counter];
      counter2++;
    }
    subtracted_string[counter2+1] = '\0';
    return subtracted_string;
  }else{
    return string1;
  }
}

#endif
