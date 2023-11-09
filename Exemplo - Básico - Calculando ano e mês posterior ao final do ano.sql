declare @AnoMes int = 201712;
declare @AnoMesPosteriorDate date = DATEADD(MONTH, @AnoMes % 100, DATEADD(YEAR, @AnoMes / 100 - 1900, 0));
declare @AnoMesPosterior int = YEAR(@AnoMesPosteriorDate) * 100 + Month(@AnoMesPosteriorDate);
select @AnoMes, @AnoMesPosterior