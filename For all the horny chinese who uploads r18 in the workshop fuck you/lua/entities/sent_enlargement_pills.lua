AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Penis Enlargement"
ENT.Category = "Adult SWEP"
ENT.Author = "No credits for the author. big gooner"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Information = ""

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

if SERVER then

function ENT:SpawnFunction( ply, tr, class )
	if ( !tr.Hit ) then return end
	local pos = tr.HitPos + tr.HitNormal * 9
	local ent = ents.Create( class )
	ent:SetPos( pos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel( "models/props_lab/jar01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:SetUseType(SIMPLE_USE)
	self:SetColor(Color(255,200,100,255))
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		--phys:SetMaterial("plastic")
	end
end

function ENT:OnTakeDamage( damage )
	self:TakePhysicsDamage(damage)
end

function ENT:Think()
	for k,v in pairs(ents.FindInSphere(self:GetPos(),16)) do
		if v:IsNPC() then
			local length = v:GetNWFloat("slarge",0)
			if length < 2 then
				v:SetNWFloat("slarge",length + 0.2 )
				v:EmitSound( "physics/glass/glass_strain2.wav", 65, 100 )
				self:Remove()
			end
		end
	end
end

function ENT:Use( activator )
	local length = activator:GetNWFloat("slarge",0)
	if length < 2 then
		activator:SetNWFloat("slarge",length + 0.2 )
		activator:EmitSound( "physics/glass/glass_strain2.wav", 50, 100 )
		activator:ChatPrint("[Adult SWEP] Your dick length has been increased. Just imagine horny fuck.")
		self:Remove()
	else
		activator:ChatPrint("[Adult SWEP] Limit has been reached, You think you can get bigger?")
	end
end

function ENT:PhysicsCollide(data, phys)
	if data.DeltaTime > 0.2 then
		if data.Speed > 250 then
			self:EmitSound("physics/plaster/ceiling_tile_impact_hard" .. math.random(1, 3) .. ".wav", 75, math.random(90,110), 0.7)
		else
			self:EmitSound("physics/plaster/ceiling_tile_impact_soft" .. math.random(1, 3) .. ".wav", 75, math.random(90,110), 0.4)
		end
	end
end

else -- CLIENT
	function ENT:Draw()
		self:DrawModel()
	end
end