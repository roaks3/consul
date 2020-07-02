NUM_ARCHIVED_VERSIONS=9

i=1
while [ "$i" -le $NUM_ARCHIVED_VERSIONS ]; do
  echo "Creating v$i"
  mkdir content/api-docs-v$i
  cp -R content/api-docs content/api-docs-v$i/.
  mkdir content/docs-v$i
  cp -R content/docs content/docs-v$i/.
  mkdir content/intro-v$i
  cp -R content/intro content/intro-v$i/.
  i=$(( i + 1 ))
done

mv content/api-docs-v* content/api-docs
mv content/docs-v* content/docs
mv content/intro-v* content/intro
