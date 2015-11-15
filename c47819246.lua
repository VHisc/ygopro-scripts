--超量機神剣－マグナスレイヤー
function c47819246.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c47819246.condition)
	e1:SetTarget(c47819246.target)
	e1:SetOperation(c47819246.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c47819246.atkval)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--multi attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47819246,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c47819246.mtcon)
	e4:SetCost(c47819246.mtcost)
	e4:SetTarget(c47819246.mttg)
	e4:SetOperation(c47819246.mtop)
	c:RegisterEffect(e4)
end
function c47819246.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c47819246.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc) and c:IsType(TYPE_XYZ)
end
function c47819246.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47819246.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47819246.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c47819246.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c47819246.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetControler()==c:GetControler() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c47819246.eqlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c47819246.eqlimit(e,c)
	return c:GetControler()==e:GetOwnerPlayer() and c:IsSetCard(0xdc) and c:IsType(TYPE_XYZ)
end
function c47819246.atkval(e,c)
	return c:GetRank()*100
end
function c47819246.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_EQUIP) and Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c47819246.mtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SetTargetCard(c:GetEquipTarget())
	Duel.SendtoGrave(c,REASON_COST)
end
function c47819246.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and not ec:IsHasEffect(EFFECT_EXTRA_ATTACK) end
end
function c47819246.mtop(e,tp,eg,ep,ev,re,r,rp)
	local ec=Duel.GetFirstTarget()
	if ec:IsLocation(LOCATION_MZONE) and ec:IsFaceup() and ec:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		ec:RegisterEffect(e1)
	end
end
