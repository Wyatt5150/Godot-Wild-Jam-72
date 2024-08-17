extends Node

enum UPGRADE_TYPE {DASH, LIGHT, DARK, SPEED}

var curScene

var weight:int = 0

var darkMax:int = -1
const darkMaxMax:int = -5

var lightMax:int = 1
const lightMaxMax:int = 5

var changeSpeed:float = 0.1
const changeSpeedMin:float = 0.1
const changeSpeedUpgradeStrength:float = .2

var hasDashUpgrade = false

func SetWeight(sweight:int):
	self.weight = sweight
	Audio.ChangeSpeed(weight)

func GetWeight():
	return self.weight

func GetWeightModifier():
	return pow(1.2, weight)

func GetDarkMax():
	return self.darkMax

func GetLightMax():
	return self.lightMax

func GetChangeSpeed():
	return self.changeSpeed

func HasDash():
	return self.hasDashUpgrade

func UpgradeHandler(upgrade_type):
	match upgrade_type:
		UPGRADE_TYPE.DARK:
			darkMax = max(darkMax + 1, darkMaxMax)
		UPGRADE_TYPE.LIGHT:
			lightMax = min(lightMax + 1, lightMaxMax)
		UPGRADE_TYPE.SPEED:
			changeSpeed = max(self.changeSpeed - changeSpeedUpgradeStrength, self.changeSpeedMin)
		UPGRADE_TYPE.DASH:
			hasDashUpgrade = true

func GetColor(weight):
	var c = (float)(weight - darkMaxMax)/ (float)(lightMaxMax-darkMaxMax)
	return Color(c,c,c,1)
