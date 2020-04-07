SELECT
  *
FROM
  [ntue-data-sci:Political_Polarization.Trump_fans_2015_06_23] 
WHERE user_id NOT IN(
SELECT
  user_id,
FROM
  [ntue-data-sci:Political_Polarization.Trump_fans_2015_06_16])
    