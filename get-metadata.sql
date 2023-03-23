-- The canonical dataset of item metadata for ease-of-querying.

WITH fieldData AS (
    SELECT id.itemID, f.fieldName, idv.value
    FROM fields f
    JOIN itemData id ON id.fieldID = f.fieldID
    JOIN itemDataValues idv ON idv.valueID = id.valueID
    WHERE f.fieldName IN (
        'title'
      , 'date'
      , 'url'
      , 'ISBN'
      , 'DOI'
      , 'ISSN'
    )
),
WITH aggCreators AS (
    SELECT 
        ic.itemID
      , GROUP_CONCAT(c.firstName || ' ' || c.lastName, '|') value
    FROM itemCreators ic
    JOIN creators c ON c.creatorID = ic.creatorID
    ORDER BY ic.orderIndex
    GROUP BY ic.itemID
),
WITH rsc AS (
    SELECT
        items.key
      , items.dateAdded date_added
      , doi.value
      , issn.value
      , isbn.value
      , url.value
      , title.value
      , authors.value
      , SUBSTRING(year.value, 1, 4)
    FROM items 
    JOIN fieldData title ON title.itemID = items.itemID AND title.fieldName = 'title'
    JOIN fieldData doi ON doi.itemID = items.itemID AND doi.fieldName = 'DOI'
    JOIN fieldData issn ON issn.itemID = items.itemID AND issn.fieldName = 'ISSN'
    JOIN fieldData isbn ON isbn.itemID = items.itemID AND isbn.fieldName = 'ISBN'
    JOIN fieldData url ON url.itemID = items.itemID AND url.fieldName = 'url'
    JOIN fieldData year ON year.itemID = items.itemID AND year.fieldName = 'date'
    JOIN aggCreators authors ON authors.itemID = items.itemID
)
SELECT * FROM rsc WHERE key = '4MMA8B7E'
