translations=$(find src -iname '*.elm' \
              | xargs grep -e 'translate model' \
              | perl -n -e'/\(translate\s+\w+\s+(.+)\)/ && print " $1,"')

template="PxAuthorisation.neededTranslations = ['TRANSLATIONS_HERE'];"

echo $template | sed -e "s/'TRANSLATIONS_HERE'/${translations%?}/g" > interop/translation-names.js
