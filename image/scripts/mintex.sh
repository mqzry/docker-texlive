#!/bin/bash -

## Invoke several compiler scripts to get the smallest possible PDF

#1 __tex__document
#2... compilers to use

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "Welcome MinLaTeX tool chain."
echo "We will invoke several pdf-LaTeX compilers in a row in the hope to obtain the smallest possible output."

# setup the (relative) paths
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$scriptDir/__texSetup__.sh"

echo "The current directory is '$__tex__currentDir' and the folder where we look for scripts is '$scriptDir'."

decisionIndex=0
minSize=2147483647
bestCompiler="undefined"

for var in "$@"
do    
    if (("$decisionIndex" > 0)) ; then
      if "$scriptDir/$var.sh" "$__tex__document"; then
        decisionIndex=$((decisionIndex+1))
        currentSize=$(stat -c%s "$__tex__document.pdf")          
        if (("$decisionIndex" > 2)) ; then
          if (("$decisionIndex" < "$#")) ; then
            if (("$minSize" > "$currentSize")) ; then
              echo "The new document produced by $var has size $currentSize, which is smaller than the smallest one we have so far (size $minSize by $bestCompiler), so we will keep it."
              minSize="$currentSize"
              mv -f "$__tex__document.pdf" "$tempFile"
              bestCompiler="$var"
            else
              echo "The new document produced by $var has size $currentSize, which is not smaller than the smallest one we have so far (size $minSize by $bestCompiler), so we will delete it."
              rm -f "$__tex__document.pdf" || true
            fi
          else
            if (("$minSize" > "$currentSize")) ; then
              echo "The new document produced by $var has size $currentSize, which is smaller than the smallest one we have so far (size $minSize by $bestCompiler), so we will keep it."
              minSize="$currentSize"
              rm -f "$tempFile" || true
              bestCompiler="$var"
            else
              echo "The new document produced by $var has size $currentSize, which is not smaller than the smallest one we have so far (size $minSize by $bestCompiler), so we will delete it."
              mv -f "$tempFile" "$__tex__document.pdf"
            fi
          fi
        else
          minSize=$(stat -c%s "$__tex__document.pdf")
          if (("$decisionIndex" < "$#")) ; then
            tempFile="$(tempfile -p=mintex -s=.pdf)"
            echo "We will use file '$tempFile' as temporary storage to hold the current-smallest pdf."
            mv -f "$__tex__document.pdf" "$tempFile"
          fi
          bestCompiler="$var"
          echo "Compiler $var has produced the first pdf document in this MinLaTeX run. It has size $minSize."
        fi
      fi
    else
       decisionIndex=1
    fi
done

if (("$decisionIndex" > 1)) ; then
  if (("$decisionIndex" < "$#")) ; then
    mv -f "$tempFile" "$__tex__document.pdf"
  fi
  decisionIndex=$((decisionIndex-1))
  echo "Finished MinLaTeX tool chain with $decisionIndex successful compilations produced document of size $minSize (with compiler '$bestCompiler')."
else
  echo "No compiler in the tool chain could compile the file!"
  exit 1
fi