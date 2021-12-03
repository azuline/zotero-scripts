-- Deleting uncategorized tags.
WITH filed_items AS (
    SELECT i.itemID
    FROM items i
    JOIN itemTypes it ON it.itemTypeID = i.itemTypeID
    WHERE
        it.itemTypeID <> 2 -- We don't want attachments.
        AND i.itemID IN (SELECT itemID FROM collectionItems)
)
SELECT t.tagID, t.name
-- DELETE
FROM tags AS t
WHERE t.tagID NOT IN (
    SELECT it.tagID
    FROM itemTags it
    WHERE it.itemID IN (SELECT fi.itemID FROM filed_items fi)
);
