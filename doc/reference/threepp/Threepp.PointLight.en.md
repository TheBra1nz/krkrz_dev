# Threepp.PointLight

Point light

A light emitted from a single point in all directions.

## Members

### Constructors

- [PointLight](#pointlight)

### Properties

- [type](#type)
- [distance](#distance)
- [decay](#decay)

### Methods

- [getPower](#getpower)
- [setPower](#setpower)
- [setShadowMapSize](#setshadowmapsize)
- [setShadowBias](#setshadowbias)
- [setShadowNormalBias](#setshadownormalbias)
- [setShadowRadius](#setshadowradius)
- [setShadowNearFar](#setshadownearfar)
- [dispose](#dispose)

---

### PointLight

Constructor

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `color` | `0xffffff` | Light color (0xRRGGBB). |
| `intensity` | `void` | Light intensity. |
| `distance` | `0` | Maximum range of the light (0 for unlimited). |
| `decay` | `1` | Decay rate. |

**Description**

Constructor

---

### type

Property \ Access: `r/w`

**Description**

"PointLight" (read-only)

---

### distance

Property \ Access: `r/w`

**Description**

Maximum range of the light

---

### decay

Property \ Access: `r/w`

**Description**

Decay rate

---

### getPower

Method

**Description**

Gets the light power

---

### setPower

Method

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `power` | `&nbsp;` |  |

**Description**

Sets the light power

---

### setShadowMapSize

Method

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `w` | `&nbsp;` |  |
| `h` | `&nbsp;` |  |

**Description**

--- Shadows (ShadowMap) --- Note: setShadowOrthoBounds is for directional lights only (it has no effect on point lights).

---

### setShadowBias

Method

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `bias` | `&nbsp;` |  |

---

### setShadowNormalBias

Method

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `bias` | `&nbsp;` |  |

---

### setShadowRadius

Method

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `radius` | `&nbsp;` |  |

---

### setShadowNearFar

Method

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `near` | `&nbsp;` |  |
| `far` | `&nbsp;` |  |

---

### dispose

Method

**Description**

Releases resources

---
