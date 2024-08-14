extends Node

var weight:int = 0

var darkMax:int = -1
const darkMaxMax:int = -5

var lightMax:int = 1
const lightMaxMax:int = 5

var changeSpeed:float = 1.0
const changeSpeedMin:float = 0.1
const changeSpeedUpgradeStrength:float = .2

var hasDashUpgrade = false

func SetWeight(weight:int):
	self.weight = weight

func GetWeight():
	return self.weight

func GetWeightModifier():
	return pow(1.2, weight)

func Get_Dark_Max():
	return self.darkMax

func GetLightMax():
	return self.lightMax

func GetChangeSpeed():
	return self.changeSpeed

func HasDash():
	return self.hasDashUpgrade

func UpgradeHandler(upgrade_type):
	match upgrade_type:
		"DarkMax":
			darkMax = max(darkMax + 1, darkMaxMax)
		"LightMax":
			lightMax = min(lightMax + 1, lightMaxMax)
		"ChangeSpeed":
			changeSpeed = max(self.changeSpeed - changeSpeedUpgradeStrength, self.changeSpeedMin)
		"Dash":
			hasDashUpgrade = true
