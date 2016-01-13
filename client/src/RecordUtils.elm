module RecordUtils where

-- Get a record that has a 'sections' property, and extract its value.
-- Useful if you want to keep a record simple by removing unnecessary nesting.
extractSections : { b | sections : a } -> a
extractSections {sections} = sections
