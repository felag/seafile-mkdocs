#!/bin/sh


# Prepare mkdocs configuration files and docs folder for a specific language
# (By default english)
# It supposes that seafile-docs translations have already been compiled.

# Read Arguments
# See <http://mywiki.wooledge.org/BashFAQ>
language=
verbose=0 # Variables to be evaluated as shell arithmetic should be initialized to a default or validated beforehand.

while :; do
    case $1 in
        -l|--language)       # Takes an option argument, ensuring it has been specified.
            if [ -n "$2" ]; then
                language="$2"
                shift
            else
                printf 'ERROR: "--language" requires a non-empty option argument.\n' >&2
                exit 1
            fi
            ;;
        --language=?*)
            language=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --language=)         # Handle the case of an empty --language=
            printf 'ERROR: "--language" requires a non-empty option argument.\n' >&2
            exit 1
            ;;
        -v|--verbose)
            verbose=$((verbose + 1)) # Each -v argument adds 1 to verbosity.
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: If no more options then break out of the loop.
            break
    esac

    shift
done

# Environment definition
MKDOCSDIR=..
MKDOCSDOCSDIR=${MKDOCSDIR}/docs
SEAFILEDOCSDIR=${MKDOCSDIR}/seafile-docs
# This file needs to exist
FILELIST=${SEAFILEDOCSDIR}/po/POTFILES.in
if [ ! -f "${FILELIST}" ]; then
  echo "${FILELIST} file does not exist ! Aborting."
  exit 1
fi

LOCALEDIR=${SEAFILEDOCSDIR}/locale
# End of environment definition

# Compute TARGET_LANGUAGE
# When not defined English website will be built
TARGETLANGUAGE=
if [ -n "${language}" ]; then
   TARGETLANGUAGE=${LOCALEDIR}/${language}

   # Check for existing compiled pages
   if [ ! -d "${TARGETLANGUAGE}" ]; then
      echo "There is no translated pages in ${TARGETLANGUAGE} ! Please compile them. Aborting."
      exit 2;
   fi
fi


# Main build
# 1- Copy files to docs directory
# 2- Create Table Of Content (and index.md file)

if [ ! -n "${TARGETLANGUAGE}" ]; then
   # 1- Copy English files to docs
   mkdir "${MKDOCSDOCSDIR}"
   cd ${SEAFILEDOCSDIR}
   while IFS= read -r file; do
      cp -p --parents "${file}" "${MKDOCSDOCSDIR}"
   done < "${FILELIST}"
   cd "$OLDPWD"
   # 2- Create Table Of Content (and index.md file)
   ./create_TOC.sh
fi
